<%@ Page MasterPageFile="../master.master" Language="C#" %>
<script runat="server">
    void Page_Init()
    {
        WebApplication1.master masterPage = (WebApplication1.master)Master;
        masterPage.subTitle = "FAQ";
        masterPage.navActive = "faq";
        masterPage.ng_app = "FAQ";
        masterPage.ng_controller = "FAQCtrl";
    }
</script>

<asp:content contentplaceholderid="head" runat="server">
    <link rel="stylesheet" href="style.css">
    <script src="controllers.js"></script>
</asp:content>

<asp:content contentplaceholderid="main" runat="server">
    <div class="main">
        <span ng-repeat="i in questions">
            <h3><span class="capital Q">Q</span>{{i.question}}</h3>
            <p><span class="capital A">A</span><span ng-bind-html="i.answer"></span></p>
        </span>
    </div>
</asp:content>
