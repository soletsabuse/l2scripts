class Paginator extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var private int nCurrentPage;
var private int nMaximumPage;
var private TextBoxHandle pageCurBox;
var private TextBoxHandle pageMaxBox;
var private ButtonHandle pageNext;
var private ButtonHandle pagePrev;
var private ButtonHandle pageFirst;
var private ButtonHandle pageMax;
var private WindowHandle Disable;
//var delegate<onPageNext> __onPageNext__Delegate;
//var delegate<onPagePrev> __onPagePrev__Delegate;

function SetPaginatorElement(TextBoxHandle _pageCurBox, TextBoxHandle _pageMaxBox, ButtonHandle _pageNext, ButtonHandle _pagePrev, ButtonHandle _pageFirst, ButtonHandle _pageMax, optional WindowHandle _disable)
{
    pageCurBox = _pageCurBox;
    pageMaxBox = _pageMaxBox;
    pageNext = _pageNext;
    pagePrev = _pagePrev;
    pageFirst = _pageFirst;
    pageMax = _pageMax;
    Disable = _disable;
    return;
}

function setAlphaBring(bool bFull)
{
    // End:0x9F
    if(bFull)
    {
        pageCurBox.SetAlpha(255, 0.0600000);
        pageMaxBox.SetAlpha(255, 0.0600000);
        pageNext.SetAlpha(255, 0.0600000);
        pagePrev.SetAlpha(255, 0.0600000);
        pageFirst.SetAlpha(255, 0.0600000);
        pageMax.SetAlpha(255, 0.0600000);
        Disable.HideWindow();        
    }
    else
    {
        pageCurBox.SetAlpha(100, 0.1500000);
        pageMaxBox.SetAlpha(100, 0.1500000);
        pageNext.SetAlpha(100, 0.1500000);
        pagePrev.SetAlpha(100, 0.1500000);
        pageFirst.SetAlpha(100, 0.1500000);
        pageMax.SetAlpha(100, 0.1500000);
        Disable.ShowWindow();
    }
    updateCurMax();
    return;
}

function setMaxPage()
{
    // End:0x16
    if(!pageMax.IsEnableWindow())
    {
        return;
    }
    nCurrentPage = nMaximumPage;
    updateCurMax();
    onPageNext();
    return;
}

function setMinPage()
{
    // End:0x16
    if(!pageFirst.IsEnableWindow())
    {
        return;
    }
    nCurrentPage = 1;
    updateCurMax();
    onPagePrev();
    return;
}

function setNextPage()
{
    // End:0x16
    if(!pageNext.IsEnableWindow())
    {
        return;
    }
    nCurrentPage++;
    // End:0x37
    if(nCurrentPage >= nMaximumPage)
    {
        nCurrentPage = nMaximumPage;
    }
    updateCurMax();
    onPageNext();
    return;
}

function setPrevPage()
{
    // End:0x16
    if(!pagePrev.IsEnableWindow())
    {
        return;
    }
    nCurrentPage--;
    // End:0x2F
    if(nCurrentPage < 1)
    {
        nCurrentPage = 1;
    }
    updateCurMax();
    onPagePrev();
    return;
}

function setCurrentPage(int nPage)
{
    nCurrentPage = nPage;
    return;
}

function int getCurrentPage()
{
    return nCurrentPage;
    return;
}

function setMaximumPage(int nPage)
{
    nMaximumPage = nPage;
    return;
}

function int getMaximumPage()
{
    return nMaximumPage;
    return;
}

function setPages(int nCurr, int nMax)
{
    nCurrentPage = nCurr;
    nMaximumPage = nMax;
    updateCurMax();
    return;
}

function bool isPageLimit()
{
    return nCurrentPage == nMaximumPage;
    return;
}

function updateCurMax()
{
    pageCurBox.SetText(string(nCurrentPage));
    pageMaxBox.SetText("/" @ string(nMaximumPage));
    // End:0x7B
    if(nMaximumPage <= 1)
    {
        pagePrev.DisableWindow();
        pageFirst.DisableWindow();
        pageNext.DisableWindow();
        pageMax.DisableWindow();        
    }
    else
    {
        // End:0xC5
        if(nCurrentPage <= 1)
        {
            pagePrev.DisableWindow();
            pageFirst.DisableWindow();
            pageNext.EnableWindow();
            pageMax.EnableWindow();            
        }
        else
        {
            // End:0x113
            if(nCurrentPage >= nMaximumPage)
            {
                pageNext.DisableWindow();
                pageMax.DisableWindow();
                pagePrev.EnableWindow();
                pageFirst.EnableWindow();                
            }
            else
            {
                pagePrev.EnableWindow();
                pageFirst.EnableWindow();
                pageNext.EnableWindow();
                pageMax.EnableWindow();
            }
        }
    }
    return;
}

delegate onPageNext()
{
    return;
}

delegate onPagePrev()
{
    return;
}
