using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MAD.Auctioning;
using MAD.DataAccessLayer;
using MAD.Security;
using System.Web.Security;

namespace MAD.Views.AuctionViews
{
    public partial class ShowAuctionView : System.Web.UI.UserControl
    {
        private User user;
        private Auction auction;
        private List<Lot> lots;        

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            string param = Page.RouteData.Values["auction_id"].ToString();
            if (String.IsNullOrEmpty(param))
            {
                param = Page.Request.QueryString["auction_id"];
            }

            Guid auctionID;
            if (Guid.TryParse(param, out auctionID))
            {
                auction = Auctions.GetAuction(auctionID);
                if (auction == null)
                {
                    Response.StatusCode = 404;
                    Response.End();                    
                }
                
                User currentUser = MADUsers.GetUser();
                if (currentUser == null || currentUser.UserID != auction.UserID)
                {
                    if (!auction.IsStarted)
                    {
                        Response.StatusCode = 404;
                        Response.End();
                    }
                    EditAuctionPlaceholder.Visible = false;
                }
                else
                {
                    EditAuctionPlaceholder.Visible = true;
                    EditAuctionLink.NavigateUrl = GetRouteUrl("EditAuctionRoute", new { auction_id = auction.AuctionID.ToString() });
                }

                lots = Auctions.GetAuctionLots(auction.AuctionID);
                user = MADUsers.GetUser(auction.UserID);

                AuctioneerLabel.Text = user.UserName;

                AuctioneerLink.NavigateUrl = GetRouteUrl("ShowUserAuctionsRoute", new { user_name = user.UserName });
                AuctioneerLink.Text = "Find other auctions from " + user.UserName;

                AuctionTitleLabel.Text = auction.AuctionTitle;

                AuctionStatusLabel.Text = !auction.IsStarted ?
                    "Not started"
                    : !auction.IsClosed ? 
                    "Active since " + auction.StartDate.ToString() 
                    : "Closed at " + auction.EndDate.ToString();

                LotsRepeater.DataSource = lots;
                LotsRepeater.DataBind();
            }
            else
            {
                Response.StatusCode = 404;
                Response.End();
            }
        }
    }
}