using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MAD.Auctioning;
using MAD.DataAccessLayer;

namespace MAD.Views.AuctionViews
{
    public partial class ShowAuctionsView : System.Web.UI.UserControl
    {
        private List<Auction> activeAuctions;

        protected bool IsAuctionActive(Object obj)
        {
            Auction auction = obj as Auction;
            if (auction == null)
                return false;
            return auction.IsStarted && !auction.IsClosed;
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            activeAuctions = Auctions.GetStartedAuctions();

            AuctionsRepeater.DataSource = activeAuctions;
            AuctionsRepeater.DataBind();
        }
    }
}