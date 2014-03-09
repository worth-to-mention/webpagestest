using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MAD.Pages.Lots
{
    public partial class SearchLotsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void SearchLotsButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string searchString = LotTitleLikeTextBox.Text.Trim();
                
                LotsRepeater.Visible = true;
                LotsRepeater.DataSource = Auctioning.Auctions.FindLots(searchString);
                LotsRepeater.DataBind();
            }
        }
    }
}