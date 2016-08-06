using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using ServiceStack.Text;
using System.Xml.Linq;

namespace eve_kill
{
    class Program
    {
        private static int N_of_data=100; //sets how many killmails are read, 30 == 600 for some reason


        static void Main(string[] args)
        {
            // A dictionary to hold typeId/count tuples
            Dictionary<Int64, int> typeIDToCount = new Dictionary<Int64, int>();

            // Read the typeId/typeName data file
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

            // Read the zkillboard loss data and parse the results
            for (int idx = 1; idx <= N_of_data; idx++)
            {
                string uri = string.Format("https://zkillboard.com/api/kills/regionID/10000002/page/{0}/api-only/", idx);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(uri);
                request.Method = WebRequestMethods.Http.Get;
                request.Accept = "application/json";
                request.UserAgent = "Alliance destroyed items script";
                request.AutomaticDecompression = DecompressionMethods.GZip;

                Console.WriteLine(string.Format("Requesting data from {0}", request.RequestUri.OriginalString));
                Killmail[] mails = null; //reset killmail array
                try
                {
                    HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                    mails = JsonSerializer.DeserializeResponse<Killmail[]>(response);
                    response.Close();
                }
                catch (System.Exception ex)
                {
                    System.Diagnostics.Debugger.Log(0, "", ex.Message);
                }
                if (mails == null)
                {
                    continue;
                }
                foreach (Killmail mail in mails) //actuall prossesing of the kill-mail
                {
                    if (mail.victim != null)
                    {
                        int value;
                        typeIDToCount.TryGetValue(mail.victim.shipTypeID, out value);
                        typeIDToCount[mail.victim.shipTypeID] = value + 1;
                    }

                    if (mail.items != null)
                    {
                        foreach (KillmailItem item in mail.items)
                        {
                            int value;
                            typeIDToCount.TryGetValue(item.typeID, out value);
                            typeIDToCount[item.typeID] = value + item.qtyDestroyed + item.qtyDropped;
                        }
                    }
                }
            }

            // Make a list of any items without a typeName
            List<Int64> neededItems = new List<Int64>();
            foreach (Int64 typeID in typeIDToCount.Keys)
            {
                ItemType record = types.FirstOrDefault(x => x.typeID == typeID);
                if (record == null)
                {
                    neededItems.Add(typeID);
                }
            }

            // Get any missing typeName data from CCP
            foreach (var chunk in neededItems.Section<Int64>(100))
            {
                StringBuilder sb = new StringBuilder("ids=");
                foreach (var typeID in chunk)
                {
                    sb.AppendFormat("{0},", typeID);
                }
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create("https://api.eveonline.com/eve/TypeName.xml.aspx");
                request.Method = WebRequestMethods.Http.Post;
                byte[] byteArray = Encoding.UTF8.GetBytes(sb.ToString(0,sb.Length-1));
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = byteArray.Length;
                Stream dataStream = request.GetRequestStream();
                dataStream.Write(byteArray, 0, byteArray.Length);
                dataStream.Close();
                Console.WriteLine(string.Format("Requesting data from {0}", request.RequestUri.OriginalString));
                try
                {
                    HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                    XDocument doc = XDocument.Load(response.GetResponseStream());
                    var rows = doc.Descendants("eveapi").Descendants("result").Descendants("rowset").Descendants("row");
                    foreach (var row in rows)
                    {
                        Int64 typeID = 0;
                        Int64.TryParse(row.Attribute("typeID").Value, out typeID);
                        string typeName = row.Attribute("typeName").Value;
                        ItemType record  = new ItemType() { typeID = typeID, typeName = typeName };
                        types.Add(record);
                    }                              
                    response.Close();
                }
                catch (System.Exception ex)
                {
                    System.Diagnostics.Debugger.Log(0, "", ex.Message);
                }

            }
            
            // Sort the loss data by descending quantity lost
            var sortedKeys = from k in typeIDToCount.Keys
                orderby typeIDToCount[k] descending
                select k;

            // Print the results
           
             
         
             try
             {
                 
                  
                
                    using (StreamWriter dataWrite = new StreamWriter( Directory.GetCurrentDirectory()+"/data.csv"))
                    {
                        foreach (var k in sortedKeys)
                        {
                            ItemType record = types.FirstOrDefault(x => x.typeID == k);
                    
                        if( record != null )
                        {
                            dataWrite.Write("{0,9}, {1} \n", typeIDToCount[k], record.typeName); 
                            
                        }
                        
                        }
                        dataWrite.Flush();
                        dataWrite.Close();
                
                     }
                 

                  // Save the typeId/typeName data file
                DirectoryInfo di = Directory.CreateDirectory(Path.GetDirectoryName(typeFile));
                using (StreamWriter sw = new StreamWriter(typeFile))
                    {
                         JsonSerializer.SerializeToWriter<ItemType[]>(types.ToArray(), sw);
                    }
             }

             catch (System.Exception ex)
             {
                 System.Diagnostics.Debugger.Log(0, "", ex.Message);
             }

           

            // Wait for the user
            Console.WriteLine("Press any key to exit...");
            

            Console.ReadKey();
        }
    }

    public class KillmailItem
    {
        public Int64 typeID { get; set; }
        public int flag { get; set; }
        public int qtyDropped { get; set; }
        public int qtyDestroyed { get; set; }
        public int singleton { get; set; }
    }

    public class KillmailVictim
    {
        public Int64 shipTypeID { get; set; }
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
        public string killTime { get; set; }
        public Int64 moonID { get; set; }
        public KillmailVictim victim { get; set; }
        public KillmailItem[] items { get; set; }
    }

    public class ItemType
    {
        public Int64 typeID { get; set; }
        public string typeName { get; set; }
    }

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

/*

[
  {
    "killID": -13132419,
    "solarSystemID": 30001020,
    "killTime": "2013-09-04 00:20:00",
    "moonID": 0,
    "victim": {
      "shipTypeID": 32878,
      "damageTaken": 3956,
      "factionName": "None",
      "factionID": 0,
      "allianceName": "Test Alliance Please Ignore",
      "allianceID": 498125261,
      "corporationName": "Barr Heavy Industries",
      "corporationID": 964993715,
      "characterName": "Sheldon-Lee Cooper",
      "characterID": 92711447
    },
    "items": [
      {
        "typeID": 27361,
        "flag": 5,
        "qtyDropped": 0,
        "qtyDestroyed": 44,
        "singleton": 0
      },
      {
        "typeID": 8091,
        "flag": 27,
        "qtyDropped": 0,
        "qtyDestroyed": 3,
        "singleton": 0
      },
      {
        "typeID": 11563,
        "flag": 11,
        "qtyDropped": 0,
        "qtyDestroyed": 1,
        "singleton": 0
      },
      {
        "typeID": 31608,
        "flag": 5,
        "qtyDropped": 0,
        "qtyDestroyed": 1,
        "singleton": 0
      },
      {
        "typeID": 26929,
        "flag": 5,
        "qtyDropped": 0,
        "qtyDestroyed": 1,
        "singleton": 0
      },
      {
        "typeID": 27361,
        "flag": 5,
        "qtyDropped": 44,
        "qtyDestroyed": 0,
        "singleton": 0
      },
      {
        "typeID": 8091,
        "flag": 28,
        "qtyDropped": 4,
        "qtyDestroyed": 0,
        "singleton": 0
      },
      {
        "typeID": 8433,
        "flag": 19,
        "qtyDropped": 1,
        "qtyDestroyed": 0,
        "singleton": 0
      },
      {
        "typeID": 400,
        "flag": 5,
        "qtyDropped": 1,
        "qtyDestroyed": 0,
        "singleton": 0
      },
      {
        "typeID": 22291,
        "flag": 12,
        "qtyDropped": 2,
        "qtyDestroyed": 0,
        "singleton": 0
      },
      {
        "typeID": 27361,
        "flag": 5,
        "qtyDropped": 392,
        "qtyDestroyed": 0,
        "singleton": 0
      },
      {
        "typeID": 8221,
        "flag": 5,
        "qtyDropped": 1,
        "qtyDestroyed": 0,
        "singleton": 0
      }
    ]
  },
  {
    "killID": 33062080,
    "solarSystemID": 30001018,
    "killTime": "2013-09-03 23:47:00",
    "moonID": 0,
    "victim": {
      "shipTypeID": 670,
      "damageTaken": 427,
      "factionName": "",
      "factionID": 0,
      "allianceName": "Test Alliance Please Ignore",
      "allianceID": 498125261,
      "corporationName": "Barr Heavy Industries",
      "corporationID": 964993715,
      "characterName": "Sheldon-Lee Cooper",
      "characterID": 92711447,
      "victim": ""
    },
    "items": [
      
    ],
    "_stringValue": "\n        \n        \n        \n      "
  }
]

*/