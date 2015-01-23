using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Sockets;
using System.IO;
using System.Web.Script.Serialization;

namespace WebApplication1
{
    public partial class random : System.Web.UI.Page
    {
        class Output
        {
            public string rand;
        }

        class DeamonRequest
        {
            public int getRandomNode = 1;
        }

        class DeamonResponse
        {
            public string status, randomName;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Headers["Content-Type"] = "application/json; charset=utf-8";
            try
            {
                JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
                TcpClient client = new TcpClient("127.0.0.1", 15244);
                StreamReader sr = new StreamReader(client.GetStream());
                StreamWriter sw = new StreamWriter(client.GetStream());
                DeamonRequest request = new DeamonRequest();
                sw.WriteLine(jsonSerializer.Serialize(request));
                sw.Flush();
                DeamonResponse response = jsonSerializer.Deserialize<DeamonResponse>(sr.ReadLine());
                Output output = new Output() { rand = response.randomName };
                Response.Write(jsonSerializer.Serialize(output));
            }
            catch { }
        }
    }
}