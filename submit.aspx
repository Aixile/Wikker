<%@ Page MasterPageFile="master.master" Language="C#" AutoEventWireup="true" CodeFile="submit.aspx.cs" Inherits="WebApplication1.submit" %>
<script runat="server">
    string description = "Wikker是一个帮助您寻找中文维基百科中两个条目之间由内部链接所组成的最短路径的工具。";
    void Page_Init()
    {
        WebApplication1.master masterPage = (WebApplication1.master)Master;
        masterPage.subTitle = "Result";
        masterPage.navActive = "home";
        masterPage.ng_app = "Result";
        masterPage.ng_controller = "ResultCtrl";
    }
</script>

<asp:Content ContentPlaceHolderId="head" runat="server">
    <% if (result.status == "0")
       {
           string tmp = string.Format("查询结果：“{0}” 与 “{1}” 之间的路径为：", result.source, result.termination);
           for (int i = 0; i < result.path.Count; i++)
           {
               tmp += result.path[i];
               if (i < result.path.Count - 1)
               {
                   tmp += " -» ";
               }
           }
           description = tmp + "    " + description;
       }
    %>
    <link rel="stylesheet" href="submit.css">
    <script src="submit.js"></script>
    <script src="controllers.js"></script>
    <script type="text/javascript" src="http://widget.renren.com/js/rrshare.js"></script>
    <script src="http://tjs.sjs.sinajs.cn/open/api/js/wb.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
        function shareClick() {
            var rrShareParam = {
                resourceUrl: 'http://wikker.halcyons.org',	//分享的资源Url
                srcUrl: 'http://wikker.halcyons.org',	//分享的资源来源Url,默认为header中的Referer,如果分享失败可以调整此值为resourceUrl试试
                pic: '',		//分享的主题图片Url
                title: 'Wikker',		//分享的标题
                description: '<%=description %>'	//分享的详细描述
            };
            rrShareOnclick(rrShareParam);
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderId="main" runat="server">
	<div class="main">
        <a class="btn btn-primary button-back" role="button">« back</a>
        <div class="share" xmlns:wb="http://open.weibo.com/wb">
            <a name="xn_share" onclick="shareClick()" type="icon" href="javascript:;" style="position: relative;top: -6px;"><span class="xn_share_wrapper xn_share_icon_small"></span></a>
            <wb:share-button appkey="" addition="simple" type="icon" default_text="<%=description %>" picture_search="false"></wb:share-button>
        </div>
        <% if (result.status=="0") { %>
            <div class="alert alert-success">
                <p><strong>Success</strong>&nbsp;&nbsp;&nbsp;&nbsp;搜索条目用时：<%=result.searchTime %>ms&nbsp;&nbsp;&nbsp;&nbsp;查询路径用时：<%=result.queryTime %>ms</p>
            </div>
            <div class="result">
            <h3>Result</h3>
            <div class="select">
                <p class="select-text">显示方式：</p>
                <select ng-model="displayMode" ng-init="displayMode = 'graphic'">
                    <option value="graphic">带超链接的图形</option>
                    <option value="link_text">带超链接的文本</option>
                    <option value="plain_text">纯文本</option>
                </select>
            </div>
            <div class="clear"></div>
            <hr />
            <span ng-if="displayMode == 'graphic'">
            <% for (int i=0;i<result.path.Count;i++) { %>
                <span class="well">
                    <a href="http://zh.wikipedia.org/wiki/<%=HttpUtility.UrlEncode(result.path[i]) %>" target="_blank"><%=result.path[i] %></a>
                </span>
                <% if (i<result.path.Count-1) { %>
                    <div class="arrow"></div>
                <% } %>
            <% } %>
            </span>
            <span ng-if="displayMode == 'link_text'">
            <% for (int i=0;i<result.path.Count;i++) { %>
                <a href="http://zh.wikipedia.org/wiki/<%=HttpUtility.UrlEncode(result.path[i]) %>" target="_blank"><%=result.path[i] %></a>
                <% if (i<result.path.Count-1) { %>
                    -&gt;
                <% } %>
            <% } %>
            </span>
            <span ng-if="displayMode == 'plain_text'">
            <% for (int i=0;i<result.path.Count;i++) { %>
                <%=result.path[i] %>
                <% if (i<result.path.Count-1) { %>
                    -&gt;
                <% } %>
            <% } %>
            </span>
            </div>
        <% }
           else { %>
            <div class="alert alert-danger">
                <p><strong>Error</strong>&nbsp;&nbsp;&nbsp;&nbsp;搜索条目用时：<%=result.searchTime %>ms&nbsp;&nbsp;&nbsp;&nbsp;查询路径用时：<%=result.queryTime %>ms</p>
                <ul class="messagelist">
                    <% if (result.status=="100") { %>
                        <li>未找到从“<%=result.source %>”到“<%=result.termination %>”的路径。</li>
                    <% } 
                       else if (result.status.StartsWith("2")) { %>
                        <li>条目“<%=result.source %>”被设置为禁止，请检查“options”栏中的设置。</li>
                    <% }
                       else if (result.status.StartsWith("3")) { %>
                        <li>条目“<%=result.termination %>”被设置为禁止，请检查“options”栏中的设置。</li>
                    <% }
                       else if (result.status.StartsWith("4")) { %>
                        <% if (result.status=="401" || result.status=="403") { %>
                            <li>无法找到条目“<%=result.source %>”，请检查输入的条目名是否正确。</li>
                        <% } %>
                        <% if (result.status=="402" || result.status=="403") { %>
                            <li>无法找到条目“<%=result.termination %>”，请检查输入的条目名是否正确。</li>
                        <% } %>
                    <% }
                       else if (result.status.StartsWith("5")) { %>
                        <li>未知错误</li>
                    <% } %>
                </ul>
            </div>
        <% } %>
        <% if (result.missingForbidNode.Count>0) { %>
            <div class="alert alert-warning">
                <p><strong>Warning</strong>&nbsp;&nbsp;&nbsp;&nbsp;以下条目未找到：</p>
                <ul class="messagelist">
                <% for (int i=0;i<result.missingForbidNode.Count;i++) { %>
                    <li><%=result.missingForbidNode[i] %></li>
                <% } %>
                </ul>
            </div>
        <% } %>
    </div>
    <div class="alert alert-info help">
        <strong>需要帮助？</strong> <a href="/faq/" target="_blank">点击此处查看常见问题解答</a>
    </div>
</asp:Content>