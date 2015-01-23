<%@ Page MasterPageFile="../master.master" Language="C#" AutoEventWireup="true" CodeFile="submit.aspx.cs" Inherits="WebApplication1.submit" %>
<script runat="server">
    void Page_Init()
    {
        WebApplication1.master masterPage = (WebApplication1.master)Master;
        masterPage.subTitle = "Contact";
        masterPage.navActive = "contact";
    }
</script>

<asp:content contentplaceholderid="head" runat="server">
    <link rel="stylesheet" href="submit.css">
</asp:content>

<asp:content contentplaceholderid="main" runat="server">
    <div class="main">
        <% if (success) { %>
            <span class="glyphicon glyphicon-ok"></span><h3>提交成功</h3>
        <% }
            else { %>
            <span class="glyphicon glyphicon-remove"></span><h3>提交失败</h3>
        <% } %>
    </div>
</asp:content>
