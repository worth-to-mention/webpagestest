using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MAD.DataAccessLayer.Extentions;

namespace MAD.DataAccessLayer.DataProviders
{
    public class AuctionDataProvider : DataProvider
    {
        public AuctionDataProvider(string connectionString)
            : base(connectionString)
        { }

        #region Auctions

        public Auction CreateAuction(Guid userID, string auctionTitle)
        {
            if (String.IsNullOrEmpty(auctionTitle))
            {
                throw new ArgumentException("Auction title can not be blank.", "auctionTitle");
            }
            Auction auction = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Auctions_CreateAuction]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                        .AddNVarChar("@auctionTitle", auctionTitle)
                        .AddBit("@isStarted", false)
                        .AddGuidOut("@auctionID")
                    .ParamsEnd()
                    .ExecuteNonQuery();
                auction = new Auction(
                    factory.GetParameter<Guid>("@auctionID"),
                    userID,
                    auctionTitle,
                    false,
                    false
                );

            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return auction;
        }

        public List<Auction> GetActiveAuctions()
        {
            List<Auction> auctions = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                auctions = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Auctions_GetActiveAuctions]")
                    .ExecuteReader()
                    .AsEnumerable()
                    .Select(record => new Auction(record))
                    .ToList();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return auctions ?? new List<Auction>();
        }

        public List<Auction> GetStartedAuctions()
        {
            List<Auction> auctions = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                auctions = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Auctions_GetStartedAuctions]")
                    .ExecuteReader()
                    .AsEnumerable()
                    .Select(record => new Auction(record))
                    .ToList();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return auctions ?? new List<Auction>();
        }

        public List<Auction> GetAllAuctions()
        {
            List<Auction> auctions = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                auctions = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Auctions_GetAllAuctions]")
                    .ExecuteReader()
                    .AsEnumerable()
                    .Select(record => new Auction(record))
                    .ToList();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return auctions ?? new List<Auction>();
        }

        public Auction GetUserAuction(Guid userID, Guid auctionID)
        {
            Auction auction = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                auction = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Auctions_GetUserAuction]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                        .AddGuid("@auctionID", auctionID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable()
                    .Select(record => new Auction(record))
                    .FirstOrDefault();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return auction;
        }

        public List<Auction> GetUserAuctions(Guid userID)
        {
            List<Auction> auctions = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                auctions = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Auctions_GetUserAuctions]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new Auction(record))
                    .ToList();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return auctions ?? new List<Auction>();
        }

        public void StartAuction(Guid auctionID, DateTime startDate)
        {
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Auctions_StartAuction]")
                    .WithParams()
                        .AddGuid("@auctionID", auctionID)
                        .AddDateTime("@startDate", startDate)
                    .ParamsEnd()
                    .ExecuteNonQuery();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
        }

        public void CloseAuction(Guid auctionID, DateTime endDate)
        {
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Auctions_CloseAuction]")
                    .WithParams()
                        .AddGuid("@auctionID", auctionID)
                        .AddDateTime("@endDate", endDate)
                    .ParamsEnd()
                    .ExecuteNonQuery();

            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
        }

        public List<Lot> GetAuctionLots(Guid auctionID)
        {
            List<Lot> lots = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                lots = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Lots_GetAuctionLots]")
                    .WithParams()
                        .AddGuid("@auctionID", auctionID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new Lot(record))
                    .ToList();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return lots ?? new List<Lot>();
        }

        public Auction GetAuction(Guid auctionID)
        {
            Auction auction = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                auction = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Auctions_GetAuction]")
                    .WithParams()
                        .AddGuid("@auctionID", auctionID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new Auction(record))
                    .FirstOrDefault();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return auction;
        }

        #endregion

        #region Bids

        public Bid CreateBid(Guid userID, Guid lotID, decimal price, DateTime bidDate)
        {
            Bid bid = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Bids_CreateBid]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                        .AddGuid("@lotID", lotID)
                        .AddMoney("@price", price)
                        .AddDateTime("@bidDate", bidDate)
                        .AddGuidOut("@bidID")
                    .ParamsEnd()
                    .ExecuteNonQuery();
                bid = new Bid(
                    factory.GetParameter<Guid>("@bidID"),
                    userID,
                    lotID,
                    price,
                    bidDate
                );
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return bid;
        }

        public List<Bid> GetLotBids(Guid lotID)
        {
            List<Bid> bids = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                bids = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Bids_GetLotBids]")
                    .WithParams()
                        .AddGuid("@lotID", lotID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new Bid(record))
                    .ToList();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return bids ?? new List<Bid>();
        }

        public List<Bid> GetUserBids(Guid userID)
        {
            List<Bid> bids = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                bids = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Bids_GetUserBids]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new Bid(record))
                    .ToList();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return bids ?? new List<Bid>();
        }

        #endregion

        #region Lots

        public Lot CreateLot(Guid auctionID, string title, string description, decimal startingPrice)
        {
            if (String.IsNullOrEmpty(title))
            {
                throw new ArgumentException("Lot title can not be blank.", "title");
            }
            if (String.IsNullOrEmpty(description))
            {
                throw new ArgumentException("Lot description can not be blank.", "description");
            }
            Lot lot = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Lots_CreateLot]")
                    .WithParams()
                        .AddGuid("@auctionID", auctionID)
                        .AddNVarChar("@lotTitle", title)
                        .AddNVarChar("@lotDescription", description)
                        .AddMoney("@startingPrice", startingPrice)
                        .AddGuidOut("@lotID")
                    .ParamsEnd()
                    .ExecuteNonQuery();
                lot = new Lot(
                    factory.GetParameter<Guid>("@lotID"),
                    auctionID,
                    title,
                    description,
                    startingPrice,
                    false
                );
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return lot;
        }

        public Decimal GetLotPrice(Guid lotID)
        {
            Decimal price = default(Decimal);
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Lots_GetLotPrice]")
                    .WithParams()
                        .AddGuid("@lotID", lotID)
                        .AddMoneyOut("@lotPrice")
                    .ParamsEnd()
                    .ExecuteNonQuery();
                price = factory.GetParameter<Decimal>("@lotPrice");
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return price;
        }

        public Lot GetLot(Guid lotID)
        {
            Lot lot = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                lot = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Lots_GetLot]")
                    .WithParams()
                        .AddGuid("@lotID", lotID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new Lot(record))
                    .FirstOrDefault();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return lot;
        }

        public void DeleteLot(Guid lotID)
        {
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Lots_DeleteLot]")
                    .WithParams()
                        .AddGuid("@lotID", lotID)
                    .ParamsEnd()
                    .ExecuteNonQuery();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
        }

        public List<Lot> SearchLotsByTitle(string searchString)
        {
            if (String.IsNullOrEmpty(searchString))
            {
                throw new ArgumentException("Search string can not be blank.", "searchString");
            }
            List<Lot> lots = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                lots = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Lots_SearchByTitle]")
                    .WithParams()
                        .AddNVarChar("@searchString", searchString)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new Lot(record))
                    .ToList();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return lots ?? new List<Lot>();
        }

        #endregion
    }
}
