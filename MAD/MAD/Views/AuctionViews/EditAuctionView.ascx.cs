using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using MAD.Auctioning;
using MAD.DataAccessLayer;
using MAD.Security;
using System.Web.Routing;

namespace MAD.Views.AuctionViews
{
    public partial class EditAuctionView : System.Web.UI.UserControl
    {
        private User user;
        private Auction auction;
        private List<Lot> lots;
        

        protected bool AuctionStarted()
        {
            return auction.IsStarted;
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            user = MADUsers.GetUser();
            if (!MADRoles.UserHasRole("Auctioneers"))
            {
                FormsAuthentication.RedirectToLoginPage();
                Response.End();
                return;
            }

            string param = Page.RouteData.Values["auction_id"].ToString();
            if (String.IsNullOrEmpty(param))
            {
                param = Page.Request.QueryString["auction_id"];
            }
            

            Guid auctionID;
            if (!Guid.TryParse(param, out auctionID))
            {
                Response.StatusCode = 404;
                Response.End();
            }
            auction = Auctions.GetAuction(auctionID);
            if (auction == null)
            {
                Response.StatusCode = 404;
                Response.End();
            }
            if (auction.UserID != user.UserID)
            {
                Response.StatusCode = 403;
                Response.End();
            }

            lots = Auctions.GetAuctionLots(auction.AuctionID);

            AuctionTitle.Text = auction.AuctionTitle;
            ShowAuctionLink.NavigateUrl = GetRouteUrl("ShowAuctionRoute", new { auction_id = auction.AuctionID.ToString() });


            if (!auction.IsStarted)
            {
                StatusButton.Text = "Start auction";
                CreateLotBlock.Visible = true;
            }
            else if (!auction.IsClosed)
            {                
                StatusButton.Text = "Close auction";                
            }
            else
            {
                AuctionStatusBlock.Visible = false;
                CreateLotBlock.Visible = false;
            }

            LotsRepeater.DataSource = lots;
            LotsRepeater.DataBind();


        }

        protected void LotsRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteLot")
            {
                if (!auction.IsStarted)
                {
                    Lot lot = lots[e.Item.ItemIndex];
                    Auctioning.Auctions.DeleteLot(lot.LotID);
                    string url = GetRouteUrl("EditAuctionRoute", new { auction_id = auction.AuctionID.ToString() });
                    Response.Redirect(url, true);
                }
            }
        }

        protected void CreateLotButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string lotTitle = LotTitleTextBox.Text.Trim();
                string lotDescription = LotDescriptionTextBox.Text.Trim();
                decimal startingPrice = Decimal.Parse(StartingPriceTextBox.Text);

                Auctions.CreateAuctionLot(auction.AuctionID, lotTitle, lotDescription, startingPrice);

                string url = GetRouteUrl("EditAuctionRoute", new { auction_id = auction.AuctionID.ToString() });
                Response.Redirect(url, true);
            }
        }

        protected void StatusButton_Click(object sender, EventArgs e)
        {
            if (!auction.IsStarted)
            {
                if (lots.Count != 0)
                {
                    Auctions.StartAuction(auction.AuctionID);
                }                
            }
            else if (!auction.IsClosed)
            {
                Auctions.CloseAuction(auction.AuctionID);
            }
            string url = GetRouteUrl("EditAuctionRoute", new { auction_id = auction.AuctionID.ToString() });
            Response.Redirect(url, true);
        }

    }
}