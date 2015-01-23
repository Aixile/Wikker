using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Sockets;
using System.IO;
using System.Web.Script.Serialization;
using System.Text.RegularExpressions;
using System.Diagnostics;
using MySql.Data.MySqlClient;

namespace WebApplication1
{
    public partial class submit : System.Web.UI.Page
    {
        class DaemonRequest
        {
            public int getRandomNode = 0, forbidFlag = 0;
            public string source, termination;
            public HashSet<string> forbidNode = new HashSet<string>();
        }

        class DaemonResponse
        {
            public string status;
            public List<string> path = new List<string>();
            public List<string> missingForbidNode = new List<string>();
            public double time;
        }

        class myWebClient
        {
            public HttpWebRequest request;
            static CookieContainer cookies = new CookieContainer();

            public myWebClient(string url)
            {
                request = WebRequest.Create(url) as HttpWebRequest;
                request.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8";
                request.Headers.Add(HttpRequestHeader.AcceptEncoding, "gzip,deflate,sdch");
                request.Headers.Add(HttpRequestHeader.AcceptLanguage, "zh-CN,zh;q=0.8");
                request.UserAgent = "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.69 Safari/537.36";
                request.CookieContainer = cookies;
                request.AllowAutoRedirect = false;
                request.Timeout = 3000;
            }
            public HttpWebResponse get()
            {
                request.Method = "GET";
                HttpWebResponse response = request.GetResponse() as HttpWebResponse;
                cookies = request.CookieContainer;
                return response;
            }
            public HttpWebResponse post(string data)
            {
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                StreamWriter sw = new StreamWriter(request.GetRequestStream());
                sw.Write(data);
                sw.Close();
                HttpWebResponse response = request.GetResponse() as HttpWebResponse;
                cookies = request.CookieContainer;
                return response;
            }
        }

        public class Result
        {
            public string status, source, termination;
            public List<string> path = new List<string>();
            public List<string> missingForbidNode = new List<string>();
            public long queryTime, searchTime;
        }

        public Result result = new Result();

        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.HttpMethod != "POST")
            {
                Response.Redirect("http://wikker.halcyons.org/");
            }
            Stopwatch stopwatch1 = new Stopwatch();
            Stopwatch stopwatch2 = new Stopwatch();
            DaemonResponse response = null;
            DaemonRequest request = new DaemonRequest() {
                source = getName(Request.Form["from"]),
                termination = getName(Request.Form["to"]),
            };
            if (Request.Form["forbidCountry"] == "on")
            {
                request.forbidFlag += 1;
            }
            if (Request.Form["forbidDate"] == "on")
            {
                request.forbidFlag += 2;
            }
            if (Request.Form["forbidAlphabet"] == "on")
            {
                request.forbidFlag += 4;
            }
            string[] forbidList = Request.Form["forbidList"].Split(new char[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string str in forbidList)
            {
                request.forbidNode.Add(getName(str));
            }
            try
            {
                stopwatch1.Start();
                response = process(request);
                stopwatch1.Stop();
                stopwatch2.Start();
                bool f = false;
                if (response.status == "401" || response.status == "403")
                {
                    string tmp = getRealName(request.source);
                    if (tmp != null)
                    {
                        request.source = tmp;
                        f = true;
                    }
                }
                if (response.status == "402" || response.status == "403")
                {
                    string tmp = getRealName(request.termination);
                    if (tmp != null)
                    {
                        request.termination = tmp;
                        f = true;
                    }
                }
                for (int i = 0; i < response.missingForbidNode.Count; i++)
                {
                    string tmp = getRealName(response.missingForbidNode[i]);
                    if (tmp != null)
                    {
                        request.forbidNode.Remove(response.missingForbidNode[i]);
                        request.forbidNode.Add(tmp);
                        f = true;
                    }
                }
                stopwatch2.Stop();
                if (f)
                {
                    stopwatch1.Restart();
                    response = process(request);
                    stopwatch1.Stop();
                }
            }
            catch (Exception ex)
            {
                stopwatch1.Stop();
                stopwatch2.Stop();
            }
            finally
            {
                if (response != null)
                {
                    result.status = response.status;
                    result.source = request.source;
                    result.termination = request.termination;
                    result.path = response.path;
                    result.missingForbidNode = response.missingForbidNode;
                    if (response.status == "0" || response.status == "100")
                    {
                        result.queryTime = stopwatch1.ElapsedMilliseconds;
                    }
                    result.searchTime = stopwatch2.ElapsedMilliseconds;
                }
                else
                {
                    result.status = "500";
                }
                writeLog();
            }
        }

        string getName(string input)
        {
            if (input.StartsWith("http://")) input = input.Remove(0, 7);
            else if (input.StartsWith("https://")) input = input.Remove(0, 8);
            if (input.StartsWith("zh.wikipedia.org/")) input = input.Remove(0, 17);
            if (input.StartsWith("zh-cn/")) input = input.Remove(0, 6);
            else if (input.StartsWith("zh-hk/")) input = input.Remove(0, 6);
            else if (input.StartsWith("zh-tw/")) input = input.Remove(0, 6);
            else if (input.StartsWith("zh-mo/")) input = input.Remove(0, 6);
            else if (input.StartsWith("zh-sg/")) input = input.Remove(0, 6);
            else if (input.StartsWith("wiki/")) input = input.Remove(0, 5);
            input = input.Replace(" ", "_");
            input = HttpUtility.UrlDecode(input);
            return input;
        }

        string getRealName(string name)
        {
            HttpWebResponse response = new myWebClient(string.Format("http://zh.wikipedia.org/w/index.php?search={0}&title=Special%3A%E6%90%9C%E7%B4%A2&go=%E5%89%8D%E5%BE%80",name)).get();
            if (response.StatusCode == HttpStatusCode.Redirect)
            {
                string realName=getName(response.Headers["Location"]);
                return realName;
            }
            else
            {
                return null;
            }
        }

        DaemonResponse process(DaemonRequest request)
        {
            TcpClient client = new TcpClient("127.0.0.1", 15244);
            StreamReader sr = new StreamReader(client.GetStream());
            StreamWriter sw = new StreamWriter(client.GetStream());
            sw.WriteLine(jsonSerializer.Serialize(request));
            sw.Flush();
            string str = sr.ReadLine();
            DaemonResponse res = jsonSerializer.Deserialize<DaemonResponse>(str);
            client.Close();
            return res;
        }

        void writeLog()
        {
            try
            {
                MySqlConnection myConnection = new MySqlConnection("server=localhost;user id=;password=;database=;charset=utf8");
                myConnection.Open();
                MySqlCommand myCommand = new MySqlCommand("INSERT INTO log VALUES (NULL , CURRENT_TIMESTAMP , @ip, @user_agent, @status, @source, @termination, @path, @missingForbidNode, @queryTime, @searchTime);", myConnection);
                myCommand.Parameters.Add("ip", Request.UserHostAddress);
                myCommand.Parameters.Add("user_agent", Request.UserAgent);
                myCommand.Parameters.Add("status", result.status);
                myCommand.Parameters.Add("source", result.source);
                myCommand.Parameters.Add("termination", result.termination);
                myCommand.Parameters.Add("path", jsonSerializer.Serialize(result.path));
                myCommand.Parameters.Add("missingForbidNode", jsonSerializer.Serialize(result.missingForbidNode));
                myCommand.Parameters.Add("queryTime", result.queryTime);
                myCommand.Parameters.Add("searchTime", result.searchTime);
                myCommand.ExecuteNonQuery();
                myConnection.Close();
            }
            catch { }
        }
    }
}