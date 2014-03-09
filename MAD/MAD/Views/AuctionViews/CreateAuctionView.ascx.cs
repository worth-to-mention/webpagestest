using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Routing;
using MAD.Auctioning;
using MAD.DataAccessLayer;
using MAD.Security;

namespace MAD.Views.AuctionViews
{
    public partial class CreateAuctionView : System.Web.UI.UserControl
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            User user = MADUsers.GetUser();
            if (user == null)
            {
                Response.StatusCode = 404;
                Response.End();
            }

        }

        protected void CreateAuctionButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string auctionTitle = AuctionTitleTextBox.Text.Trim();
                Auction auction = Auctions.CreateAuction(auctionTitle);
                var routeParameters = new RouteValueDictionary
                {
                    { "auction_id", auction.AuctionID.ToString() }
                };
                Response.Redirect(GetRouteUrl("EditAuctionRoute", routeParameters));
            }
        }
    }
}