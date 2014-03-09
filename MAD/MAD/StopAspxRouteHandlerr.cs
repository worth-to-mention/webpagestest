using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;

namespace MAD
{
    public class StopASPXRouteHandler : IRouteHandler, IHttpHandler
    {
        #region IHttpHandler Members

        public bool IsReusable
        {
            get { return false; }
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.StatusCode = 404;
            context.Response.End();
        }

        #endregion

        #region IRouteHandler Members

        public IHttpHandler GetHttpHandler(RequestContext requestContext)
        {
            return this;
        }

        #endregion
    }
}