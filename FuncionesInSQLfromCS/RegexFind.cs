using System;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;
using INDAABIN_Utilerias;


public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlBoolean fncRegexFind(SqlString regex, SqlString text)
    {
        Regex rx = new Regex((string) regex, RegexOptions.Compiled | RegexOptions.IgnoreCase);
        MatchCollection matches = rx.Matches((string) text);

        if (matches.Count > 0)
            return (SqlBoolean)true;
        else
            return (SqlBoolean)false;
    }

    [Microsoft.SqlServer.Server.SqlFunction]
    static public SqlString EDS(SqlString valor)
    {
        return (SqlString)U.EDS((string)valor);
    }
}
