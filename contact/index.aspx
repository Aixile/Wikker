<%@ Page MasterPageFile="../master.master" Language="C#" %>
<script runat="server">
    void Page_Init()
    {
        WebApplication1.master masterPage = (WebApplication1.master)Master;
        masterPage.subTitle = "Contact";
        masterPage.navActive = "contact";
    }
</script>

<asp:content contentplaceholderid="head" runat="server">
    <link rel="stylesheet" href="style.css">
    <script src="script.js"></script>
</asp:content>

<asp:content contentplaceholderid="main" runat="server">
    <div class="main">
        <form id="form1" method="post" action="submit.aspx">
            <p class="long-p">您可以在这里提出问题，或者发表意见和建议。如果想报告错误，请注明引起错误的操作步骤（如输入的内容、选项）等。</p>
            <textarea class="textarea1 form-control" name="content"></textarea>
            <p class="inline">E-mail（可选）：</p>
            <input class="text1 form-control" name="e-mail" />
            <div class="submit">
                <a class="btn btn-primary button-submit" role="button">Submit »</a>
            </div>
        </form>
    </div>
</asp:content>
