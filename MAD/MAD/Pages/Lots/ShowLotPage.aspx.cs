using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MAD.DataAccessLayer;
using MAD.Auctioning;
using System.Web.Security;
using MAD.Security;
namespace MAD.Pages.Lots
{
    public partial class ShowLotPage : System.Web.UI.Page
    {
        private Auction auction;
        private Lot lot;
        private List<Bid> bids;
        private decimal currentPrice;

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            string param = RouteData.Values["lot_id"].ToString();

            Guid lotID;
            if (!Guid.TryParse(param, out lotID))
            {
                Response.StatusCode = 404;
                Response.End();
            }
            
            lot = Auctioning.Auctions.GetLot(lotID);
            if (lot == null)
            {
                Response.StatusCode = 404;
                Response.End();
            }

            auction = Auctioning.Auctions.GetAuction(lot.AuctionID);
            if (auction == null)
            {
                Response.StatusCode = 404;
                Response.End();
            }

            currentPrice = Auctioning.Auctions.GetLotSumPrice(lot.LotID);

            bids = Auctioning.Auctions.GetLotBids(lot.LotID);
            if (bids.Count == 0)
            {
                BidsRepeater.Visible = false;
            }
            else
            {
                BidsRepeater.Visible = true;
            }
            BidsRepeater.DataSource = bids;
            BidsRepeater.DataBind();

            AuctionLink.NavigateUrl = GetRouteUrl("ShowAuctionRoute", new { auction_id = auction.AuctionID.ToString() });
            AuctionLink.Text = auction.AuctionTitle;
            LotTitleLabel.Text = lot.Title;
            LotDescriptionLabel.Text = lot.Description;
            LotStartingPriceLabel.Text = lot.StartingPrice.ToString();
            LotCurrentPriceLabel.Text = currentPrice.ToString();
            LotStatusLabel.Text = lot.IsSold ? "Sold" : "Not sold";

            User currentUser = MADUsers.GetUser();

            if (!auction.IsStarted || auction.IsClosed || lot.IsSold || auction.UserID == currentUser.UserID)
            {
                BidPlaceholder.Visible = false;
            }



        }

        protected void LeaveBidButton_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;
            if (!auction.IsStarted || auction.IsClosed || lot.IsSold)
                return;
            decimal bidPrice;
            if (Decimal.TryParse(BidPriceTextBox.Text.Trim(), out bidPrice))
            {
                if (!MADRoles.UserHasRole("Bidders"))
                {
                    FormsAuthentication.RedirectToLoginPage();
                    Response.End();
                }
                User user = MADUsers.GetUser();
                if (user == null)
                {
                    FormsAuthentication.RedirectToLoginPage();
                    Response.End();
                }

                Auctioning.Auctions.Bid(user.UserID, lot.LotID, bidPrice);

                string url = GetRouteUrl("ShowLotRoute", new { lot_id = lot.LotID.ToString() });
                Response.Redirect(url, true);

            }
        }
    }
}