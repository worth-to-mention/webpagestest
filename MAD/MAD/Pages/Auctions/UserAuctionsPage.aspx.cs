using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MAD.DataAccessLayer;
using MAD.Security;

namespace MAD.Pages.Auctions
{
    public partial class UserAuctionsPage : System.Web.UI.Page
    {
        private User user;
        private List<Auction> auctions;

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            string userName = RouteData.Values["user_name"].ToString();
            if (String.IsNullOrEmpty(userName))
            {
                Response.StatusCode = 404;
                Response.End();
                return;
            }
            user = MADUsers.GetUser(userName);            
            if (user == null)
            {
                Response.StatusCode = 404;
                Response.End();
                return;
            }
            auctions = Auctioning.Auctions.GetUserAuctions(user.UserID);

            User currentUser = MADUsers.GetUser();
            if (currentUser == null || user.UserID != currentUser.UserID)
            {

                AuctionsRepeater.DataSource = auctions.Where(el => el.IsStarted).ToList();
            }
            else
            {
                AuctionsRepeater.DataSource = auctions;
            }
            AuctionsRepeater.DataBind();
        }

        protected bool IsAuctionActive(Object obj)
        {
            Auction auction = obj as Auction;
            if (auction == null)
                return false;
            return auction.IsStarted && !auction.IsClosed;
        }
    }
}