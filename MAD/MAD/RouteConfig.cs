using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;

using MAD.Extentions;

namespace MAD
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.RouteExistingFiles = true;
            routes.AppendTrailingSlash = true;

            routes.StopASPXRequests();

            routes.MapPageRoute(
                "DefaultRoute",
                "",
                "~/Pages/DefaultPage.aspx"
            );

            routes.MapPageRoute(
                "LoginRoute",
                "login",
                "~/Pages/LoginPage.aspx"
            );

            routes.MapPageRoute(
                "RegisterRoute",
                "register/{role}",
                "~/Pages/RegisterPage.aspx",
                false,
                new RouteValueDictionary 
                {
                    {"role", "choose"}
                },
                new RouteValueDictionary
                {
                    {"role", @"auctioneers|bidders|choose"}
                }
            );


            routes.MapPageRoute(
                "ShowAuctionRoute",
                "auction/{auction_id}/{page_number}/{items_per_page}",
                "~/Pages/Auctions/ShowAuctionPage.aspx",
                false,
                new RouteValueDictionary
                            {
                                { "page_number", 0 },
                                { "items_per_page", 20 }
                            }
            );

            routes.MapPageRoute(
                "CreateAuctionRoute",
                "auctions/create_auction",
                "~/Pages/Auctions/CreateAuctionPage.aspx"
            );

            routes.MapPageRoute(
                "EditAuctionRoute",
                "auctions/edit_auction/{auction_id}",
                "~/Pages/Auctions/EditAuctionPage.aspx"
            );


            routes.MapPageRoute(
                "ShowUserAuctionsRoute",
                "auctions/{user_name}",
                "~/Pages/Auctions/UserAuctionsPage.aspx"
            );

            routes.MapPageRoute(
                "AuctionsRoute",
                "auctions",
                "~/Pages/Auctions/AuctionsPage.aspx"
            );

            routes.MapPageRoute(
                "ShowLotRoute",
                "lot/{lot_id}",
                "~/Pages/Lots/ShowLotPage.aspx"
            );

            routes.MapPageRoute(
                "BidsRoute",
                "bids/{lot_id}",
                "~/Pages/BidsPages/ShowBids.aspx"
            );


            routes.MapPageRoute(
                "CreateUsersRoute",
                "administrative/users",
                "~/Pages/Administrative/CreateUsersPage.aspx",
                true
            );
            routes.MapPageRoute(
                "CreateRolesRoute",
                "administrative/roles",
                "~/Pages/Administrative/CreateRolesPage.aspx",
                true
            );
            routes.MapPageRoute(
                "UserRolesRoute",
                "administrative/roles/{user_name}",
                "~/Pages/Administrative/AssignRolesToUserPage.aspx",
                true
            );

            routes.MapPageRoute(
                "AdministrativeRoute",
                "administrative",
                "~/Pages/Administrative/AdministrativePage.aspx",
                true
            );


            routes.MapPageRoute(
                "SearchLotsRoute",
                "search",
                "~/Pages/Lots/SearchLotsPage.aspx"
            );


        }
    }
}