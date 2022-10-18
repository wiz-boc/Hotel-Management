using System.Collections.Generic;

namespace HotelAppLibrary.Databases
{
    public interface ISqlDataAccess
    {
        List<T> LoadData<T, U>(string sqlStatement, U parameters, string connectionStringName, bool iSStoredProcedure = false);
        void SaveData<U>(string sqlStatement, U parameters, string connectionStringName, bool iSStoredProcedure = false);
    }
}