using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
 
namespace WebApplication1
{
    public partial class submit : System.Web.UI.Page
    {
        public bool success = false;
        void Page_Load()
        {
            try
            {
                MySqlConnection myConnection = new MySqlConnection("server=localhost;user id=;password=;database=;charset=utf8");
                myConnection.Open();
                MySqlCommand myCommand = new MySqlCommand("INSERT INTO contact VALUES (NULL , CURRENT_TIMESTAMP , @ip, @user_agent, @content, @e_mail);", myConnection);
                myCommand.Parameters.Add("ip", Request.UserHostAddress);
                myCommand.Parameters.Add("user_agent", Request.UserAgent);
                myCommand.Parameters.Add("content", Request.Form["content"]);
                myCommand.Parameters.Add("e_mail", Request.Form["e-mail"]);
                myCommand.ExecuteNonQuery();
                myConnection.Close();
                success = true; 
            }
            catch { }
        }
    }
}