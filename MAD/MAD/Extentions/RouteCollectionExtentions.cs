using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;

namespace MAD.Extentions
{
    public static class RouteCollectionExtentions
    {
        public static void StopASPXRequests(this RouteCollection routes)
        {
            routes.Add(new Route(
                "{*pages}",
                null,
                new RouteValueDictionary
                {
                    { "pages", @"?i:^.*.aspx.*$" }
                },
                new StopASPXRouteHandler()
            ));
        }
    }
}