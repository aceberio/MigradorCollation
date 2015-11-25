using System;
using System.Data.SqlClient;
using System.Text;

namespace AlterCollation
{
    class Utils
    {
        private Utils()
        {
        }

        public static string ConnectionString(string server, string userId, string password, string initialCatalog)
        {
            return Utils.ConnectionString(server, userId, password, 2, initialCatalog);
        }
        public static string ConnectionString(string server, string userId, string password)
        {
            return Utils.ConnectionString(server, userId, password, 2, "master");
        }
        /// <summary>
        /// build up a connection string for given some connection parameters
        /// </summary>
        /// <param name="server"></param>
        /// <param name="userId"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public static string ConnectionString(string server, string userId, string password, int timeOut, string initialCatalog)
        {
            //StringBuilder stringBuilder = new StringBuilder();
            SqlConnectionStringBuilder stringBuilder = new SqlConnectionStringBuilder();
            stringBuilder.DataSource = server;
            
            stringBuilder.ApplicationName = "CSL Change Collation";
            //stringBuilder.Trusted_Connection = "SSPI";
            stringBuilder.InitialCatalog = initialCatalog;
            stringBuilder.ConnectTimeout = timeOut;
            stringBuilder.Pooling = false;
            stringBuilder.PersistSecurityInfo = false;
            if (string.IsNullOrEmpty(userId) || string.IsNullOrEmpty(password))
            {
                stringBuilder.IntegratedSecurity = true; 
                
            }
            else {
                stringBuilder.IntegratedSecurity = false;
                stringBuilder.UserID = userId;
                stringBuilder.Password = password;                
            }

            return stringBuilder.ToString();
        }
    }
}
