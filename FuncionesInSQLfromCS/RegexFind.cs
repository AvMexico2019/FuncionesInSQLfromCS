using System;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;


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
        char[] quitarChars = { ' ', '"' };
        if (IsExcelNull((string)valor))
            return "";
        else
        {
            byte[] tempBytes;
            tempBytes = System.Text.Encoding.GetEncoding("ISO-8859-8").GetBytes((string)valor);
            string asciiStr = System.Text.Encoding.UTF8.GetString(tempBytes);
            return (SqlString)System.Text.RegularExpressions.Regex.Replace(asciiStr, @"\s+", " ").Trim(quitarChars).ToLower();
        }

    }

    static public bool IsExcelNull(string valor)
    {
        if (String.IsNullOrEmpty(valor) || valor.Equals("NULL") || String.IsNullOrWhiteSpace(valor)) return true; else return false;
    }
}
