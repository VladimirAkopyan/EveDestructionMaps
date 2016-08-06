using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using ServiceStack.Text;
using System.Xml.Linq;
using System.Xml;
using System.Data.SqlClient;
using System.Threading;

namespace eve_kill
{
    class Program
    {
        /*sets how many killmails are read for each entity, how far back into the past we go,
         * 30 == 600, each one is 20 */
        private static int N_of_data = 500; 
        private static Killmail[][] KillData = new Killmail[N_of_data][]; //set killmail array

        /* Setting for a connection to eve static database running at localhost*/
        static SqlConnection eveStatDB = new SqlConnection("user id=USER NAME;" +
                                       "password=Password;server=localhost\\MSSQL;" +
                                       "Trusted_Connection=yes;" +
                                       "database=eveonline; " +
                                       "connection timeout=15");

        static void Main(string[] args)
        {
            // A dictionary to hold typeId/count tuples
            Dictionary<Int64, int> typeIDToCount = new Dictionary<Int64, int>();


            /* Read the typeId/typeName data file. This is depreasheated and no longer nessesary*/
            string typeFile = Path.Combine(new string[] { Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "eve-kill", "types.json" });
            HashSet<ItemType> types = new HashSet<ItemType>(); //list of all types is stores in AppData/Local/Eve-kill
            try
            {
                using (StreamReader sr = new StreamReader(typeFile))
                {
                    var records = JsonSerializer.DeserializeFromReader<ItemType[]>(sr);
                    if (records != null)
                    {
                        types = new HashSet<ItemType>(records);
                    }
                }
            }
            catch (System.Exception ex)
            {
                System.Diagnostics.Debugger.Log(0, "", ex.Message);
            }

            /*try to establish connection with local MSSQL DB server*/
            try
            {
                eveStatDB.Open();
                if (eveStatDB.State.ToString() == "Open")
                    Console.WriteLine("Connection to Eve Static established \n");

            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }

            /* a loop for pulling data from Zkillboard and pushing it on the SQL server
             Number is replace with a random function, which allows pulling data about randomly chosen characters*/
            for (int i = 1; i < 2; i++)
            {
                if (GetZkbData(KillData, 90573883))
                    SQLRecord(KillData, types);
            }

            // Wait for the user
            Console.WriteLine("Press any key to exit...");
            Console.ReadKey();
        }

        /* Connect to Zkillboard and recieve data*/
        static bool GetZkbData(Killmail[][] KillData, int region)
        {
            for (int idx = 1; idx <= N_of_data; idx++)
            {
                string uri = string.Format("https://zkillboard.com/api/characterID/{0}/page/{1}", region.ToString(), idx); //
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(uri);
                request.Method = WebRequestMethods.Http.Get;
                request.Accept = "application/json";
                request.UserAgent = "Alliance destroyed items script";
                request.AutomaticDecompression = DecompressionMethods.GZip;

                Console.WriteLine(string.Format("Requesting data from {0}", request.RequestUri.OriginalString));
                Killmail[] mails = null; //create empty reference to array of mails. 
                try
                { 
                    HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                    mails = JsonSerializer.DeserializeResponse<Killmail[]>(response);
                    KillData[idx - 1] = mails;
                    response.Close();
                }
                catch (System.Exception ex)
                {
                    System.Diagnostics.Debugger.Log(0, "", ex.Message);
                }

                /* Checks if any kills ehre retrieved */
                if (idx == 1 && mails.Length == 0)
                    return false;
                else if (mails.Length == 0)
                    break;
            }
            return true;
        }

        /*Write all the information into the SQL server*/
        static void SQLRecord(Killmail[][] KillData, HashSet<ItemType> types)
        {
            int Svictim = 0;
            int attackerCount = 0;
            int ItemCount = 0;
            SqlCommand writeValues = new SqlCommand("", eveStatDB);

            foreach (Killmail[] v in KillData)
            {
                try
                {
                    foreach (Killmail k in v)
                    {
                        /*Remove all the hyphens, because they confuse both sql commands and data analysis software*/
                        k.victim.characterName = k.victim.characterName.Replace("'", "");
                        k.victim.corporationName = k.victim.corporationName.Replace("'", "");
                        k.victim.allianceName = k.victim.allianceName.Replace("'", "");
                        k.victim.factionName = k.victim.factionName.Replace("'", "");


                        /* insert information about the victims*/
                        try
                        {   /*                                        cID  kID        TIME         cID  aID  fID  shiID DMG    SSID MOON?  */
                            string insertion = string.Format("Values ({0}, {1}, '{2}-{3}-{4} {5}', {6}, {7}, {8}, {9}, {10}, {11}, {12})",
                                k.victim.characterID.ToString(), k.killID, k.killTime.Year, k.killTime.Month.ToString("d2"), k.killTime.Day, k.killTime.ToLongTimeString(),
                                k.victim.corporationID.ToString(), k.victim.allianceID.ToString(), k.victim.factionID,
                                k.victim.shipTypeID, k.victim.damageTaken, k.solarSystemID, k.moonID);


                            writeValues.CommandText = "INSERT INTO [dbo].[zkbVictims] (charID, killID, Time, " +
                                "corpID, allienceID, factionID, shipID, damage, solarSystemID, moonID) "
                                + insertion;

                            writeValues.ExecuteNonQuery();
                            Svictim++;
                        }
                        catch (System.Exception ex)
                        {
                            System.Diagnostics.Debugger.Log(0, "", ex.Message);
                        }



                        /* insert information about each attacker*/
                        foreach (KillmailAttackers i in k.attackers)
                        {
                            i.characterName = i.characterName.Replace("'", "");
                            i.corporationName = i.corporationName.Replace("'", "");
                            i.allianceName = i.allianceName.Replace("'", "");
                            i.factionName = i.factionName.Replace("'", "");

                            //                                                                         SID  WID  DMG  CID    COID    AID   FID  Final  SolarID Sec
                            string insertion2 = string.Format("Values ({0}{1}, {2}, '{3}-{4}-{5} {6}', {7}, {8}, {9}, {10},  {11},  {12}, {13}, '{14}', {15}, {16})",
                                k.killID, attackerCount.ToString("d3"), k.killID, k.killTime.Year, k.killTime.Month.ToString("d2"), k.killTime.Day, k.killTime.ToLongTimeString(),
                                i.shipTypeID, i.weaponTypeID, i.damageDone, i.characterID, i.corporationID, i.allianceID, i.factionID,
                                i.finalBlow, k.solarSystemID, i.securityStatus);


                            writeValues.CommandText = "INSERT INTO [dbo].[zkbAttackers] (AttackID, KillID, Time," +
                                "shipID, weapon, damage, charID, corpID, allienceID, factionID, finalBlow, solarSystemID, security) "
                                + insertion2;

                            try
                            {
                                writeValues.ExecuteNonQuery();
                                attackerCount++;
                            }
                            catch (System.Exception ex)
                            {
                                System.Diagnostics.Debugger.Log(0, "", ex.Message);
                            }
                        }

                        /* insert information about each itme the victim had*/
                        foreach (KillmailItem i in k.items)
                        {


                            string insertion3 = string.Format("Values ({0}{1}, {2}, {3}, {4}, {5})",
                                k.killID, ItemCount.ToString("d4"), k.killID, i.typeID, i.qtyDropped, i.qtyDestroyed);

                            writeValues.CommandText = "INSERT INTO [dbo].[zkbItems] (ItemDropID, KillID, ItemID," +
                                "QtyDropped, QtyDestroyed) "
                                + insertion3;

                            try
                            {
                                writeValues.ExecuteNonQuery();
                                ItemCount++;
                            }
                            catch (System.Exception ex)
                            {
                                System.Diagnostics.Debugger.Log(0, "", ex.Message);
                            }

                        }

                    }
                }
                catch (System.Exception ex)
                {
                    System.Diagnostics.Debugger.Log(0, "", ex.Message);
                    break;
                }
            }

            /* it's nice to have some real-time feedback*/
            Console.WriteLine("{0} victim, {1} attackers, {2} items added to database", Svictim, attackerCount, ItemCount);

        }

        /*depreceated*/
        public class Alpha
        {

            // This method that will be called when the thread is started
            public void Beta()
            {
                while (true)
                {
                    Console.WriteLine("Alpha.Beta is running in its own thread.");
                }
            }
        };

        /*data storage*/
        public class KillmailItem
        {
            public Int64 typeID { get; set; }
            public string typeName { get; set; } //must be filled in at lookup
            public int flag { get; set; }
            public int qtyDropped { get; set; }
            public int qtyDestroyed { get; set; }
            public int singleton { get; set; }
        }

        public class KillmailAttackers
        {
            public Int64 shipTypeID { get; set; }
            public string shipType { get; set; } //must be filled in at lookup
            public float securityStatus { get; set; }
            public Int64 weaponTypeID { get; set; }
            public string weaponType { get; set; }
            public bool finalBlow { get; set; }
            public Int64 damageDone { get; set; }
            public string factionName { get; set; }
            public Int64 factionID { get; set; }
            public string allianceName { get; set; }
            public Int64 allianceID { get; set; }
            public string corporationName { get; set; }
            public Int64 corporationID { get; set; }
            public string characterName { get; set; }
            public Int64 characterID { get; set; }
        }

        public class KillmailVictim
        {
            public Int64 shipTypeID { get; set; }
            public string shipType { get; set; }
            public Int64 damageTaken { get; set; }
            public string factionName { get; set; }
            public Int64 factionID { get; set; }
            public string allianceName { get; set; }
            public Int64 allianceID { get; set; }
            public string corporationName { get; set; }
            public Int64 corporationID { get; set; }
            public string characterName { get; set; }
            public Int64 characterID { get; set; }
        }

        public class Killmail
        {
            public Int64 killID { get; set; }
            public Int64 solarSystemID { get; set; }
            public string solarSystem { get; set; }
            public DateTime killTime { get; set; }
            public Int64 moonID { get; set; }
            public KillmailVictim victim { get; set; }
            public KillmailItem[] items { get; set; }
            public KillmailAttackers[] attackers { get; set; }
        }

        public class ItemType
        {
            public Int64 typeID { get; set; }
            public string typeName { get; set; }
        }

        /* depreaseacted */ 
        static class LinqExtensions
        {
            public static IEnumerable<IEnumerable<T>> Section<T>(this IEnumerable<T> source, int length)
            {
                if (length <= 0)
                    throw new ArgumentOutOfRangeException("length");

                var section = new List<T>(length);

                foreach (var item in source)
                {
                    section.Add(item);

                    if (section.Count == length)
                    {
                        yield return section.AsReadOnly();
                        section = new List<T>(length);
                    }
                }

                if (section.Count > 0)
                    yield return section.AsReadOnly();
            }
        }
    }
}
