using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace MAD.Extentions
{
    public static class ListItemCollectionExtentions
    {
        public static IEnumerable<ListItem> AsEnumerable(this ListItemCollection listItemCollection)
        {
            foreach(ListItem item in listItemCollection)
            {
                yield return item;
            }
        }
    }
}