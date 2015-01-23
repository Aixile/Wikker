<%@ Page MasterPageFile="../master.master" Language="C#" %>
<script runat="server">
    void Page_Init()
    {
        WebApplication1.master masterPage = (WebApplication1.master)Master;
        masterPage.subTitle = "About";
        masterPage.navActive = "about";
    }
</script>

<asp:content contentplaceholderid="head" runat="server">
    <link rel="stylesheet" href="style.css">
    <script src="script.js"></script>
</asp:content>

<asp:content contentplaceholderid="main" runat="server">
    <div class="main">
        <h1>Wikker Version 2.0.0</h1>
        <h4>Author：</h4>
		<p>zhangjk95&nbsp;&nbsp;[zjk_261011@163.com]</p>
		<p>Aixile&nbsp;&nbsp;[kaguyaelf@gmail.com]</p>
        <h4>Current Database： </h4>
		<p><a href="http://download.wikipedia.com/zhwiki/20140823/">http://download.wikipedia.com/zhwiki/20140823/</a></p>
        <p>(update time: 2014/09/10)</p>
    </div>
</asp:content>
