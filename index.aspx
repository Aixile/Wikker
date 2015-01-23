<%@ Page MasterPageFile="master.master" Language="C#" %>
<script runat="server">
    void Page_Init()
    {
        WebApplication1.master masterPage = (WebApplication1.master)Master;
        masterPage.navActive = "home";
    }
</script>

<asp:Content ContentPlaceHolderId="head" runat="server">
    <link rel="stylesheet" href="style.css">
    <script src="script.js"></script>
    <script type="text/javascript" src="http://widget.renren.com/js/rrshare.js"></script>
    <script src="http://tjs.sjs.sinajs.cn/open/api/js/wb.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
        function shareClick() {
            var rrShareParam = {
                resourceUrl: 'http://wikker.halcyons.org',	//分享的资源Url
                srcUrl: 'http://wikker.halcyons.org',	//分享的资源来源Url,默认为header中的Referer,如果分享失败可以调整此值为resourceUrl试试
                pic: '',		//分享的主题图片Url
                title: 'Wikker',		//分享的标题
                description: 'Wikker -- 一个帮助您寻找中文维基百科中两个条目之间由内部链接所组成的最短路径的工具。'	//分享的详细描述
            };
            rrShareOnclick(rrShareParam);
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderId="main" runat="server">
	<div class="main">
        <div class="share" xmlns:wb="http://open.weibo.com/wb">
            <a name="xn_share" onclick="shareClick()" type="icon" href="javascript:;" style="position: relative;top: -6px;"><span class="xn_share_wrapper xn_share_icon_small"></span></a>
            <wb:share-button appkey="" addition="simple" type="icon" default_text="Wikker -- 一个帮助您寻找中文维基百科中两个条目之间由内部链接所组成的最短路径的工具。" picture_search="false"></wb:share-button>
        </div>
        <form id="form1" method="post" action="submit.aspx">
            <div class="input-group-outer">
                <div class="input-group">
                    <input type="text" name="from" placeholder="from" class="form-control text-from">
                    <span class="input-group-addon random random1">random</span>
                </div>
            </div>
            <div class="arrow" title="swap"></div>
            <div class="input-group-outer">
                <div class="input-group">
                    <input type="text" name="to" placeholder="to" class="form-control text-to">
                    <span class="input-group-addon random random2">random</span>
                </div>
            </div>
            <div class="advanced">
                <div class="show-options">
                    <h4>options</h4>
                    <span class="glyphicon glyphicon-play-circle show-options-icon"></span>
                </div>
                <div class="options">
                    <div class="options-left">
                        <p>禁止路径中包含：</p>
                        <div>
                            <input type="checkbox" name="forbidCountry" checked="checked"><p class="option">国家</p>
                        </div>
                        <div>
                            <input type="checkbox" name="forbidDate" checked="checked"><p class="option">日期</p>
                        </div>
                        <div>
                            <input type="checkbox" name="forbidAlphabet" checked="checked"><p class="option">字母</p>
                        </div>
                    </div>
                    <div class="options-right">
                        <p>其他禁止包含的条目（每行一个）</p>
                        <textarea name="forbidList" class="textarea1 form-control"></textarea>
                    </div>
                </div>
            </div>
            <div class="submit">
                <a class="btn btn-primary btn-lg button-submit" role="button">Go »</a>
            </div>
        </form>
	</div>
    <div class="alert alert-info help">
        <strong>需要帮助？</strong> <a href="/faq/" target="_blank">点击此处查看常见问题解答</a>
    </div>
</asp:Content>