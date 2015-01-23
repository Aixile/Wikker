using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace WebApplication1
{
    public partial class master : System.Web.UI.MasterPage
    {
        public string subTitle, navActive, ng_app, ng_controller;

        void Page_Load()
        {
            if (subTitle == null)
            {
                title.Text = "Wikker";
            }
            else
            {
                title.Text = subTitle + " - Wikker";
            }
            if (ng_app != null)
            {
                html.Attributes.Add("ng-app", ng_app);
            }
            if (ng_controller != null)
            {
                body.Attributes.Add("ng-controller", ng_controller);
            }
            if (navActive == "home")
            {
                nav_home.Attributes.Add("class", "active");
            }
            else if (navActive == "about")
            {
                nav_about.Attributes.Add("class", "active");
            }
            else if (navActive == "contact")
            {
                nav_contact.Attributes.Add("class", "active");
            }
            else if (navActive == "faq")
            {
                nav_faq.Attributes.Add("class", "active");
            }
        }
    }
}