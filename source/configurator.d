module skoenlapper.configurator;

import std.json;
import gogga;
import std.stdio;

public final class Configuration
{
    public static Configuration getConfiguration(JSONValue json)
    {
        /* The generated configuration */
        Configuration configuration = new Configuration();




        return configuration;
    }
}

public JSONValue getConfiguration()
{
    /* The JSON configuration file */
    JSONValue config;

    /* Read the configuration file */
    File configFile;
    configFile.open("~/.config/butterfly/butterfly.json", "rb");
    byte[] configuration;
    configuration.length = configFile.size();
    configuration = configFile.rawRead(configuration);
    configFile.close();

    /* Parse the JSON */
    config = parseJSON(cast(string)configuration);

    return config;
}

public final class Account
{
    private string[] authenticationCredentials;
    private string server;

    this(string[] authenticationCredentials, string server)
    {
        this.authenticationCredentials = authenticationCredentials;
        this.server = server;
    }

    public string getUsername()
    {
        return authenticationCredentials[0];
    }

    public string getPassword()
    {
        return authenticationCredentials[1];
    }

    public string getServer()
    {
        return server;
    }

    public static Account[] getAccounts(JSONValue accountBlock)
    {
        /* All the accounts generated */
        Account[] accounts;

        /* Find all accounts */
        foreach(JSONValue account; accountBlock["active"].array())
        {
            /* The account to activate */
            string accountName = account.str();

            /* Generate the account (TODO: Error handling for key not found) */
            accounts ~= getAccount(accountBlock[accountName]);

            gprintln("Activated account '"~accountName~"'");
        }

        return accounts;
    }

    private static Account getAccount(JSONValue accountBlock)
    {
        /* The generated account */
        Account account;

        /* Get the authentication credentials (TODO: Key not found exception handling) */
        string[] authenticationCredentials;
        authenticationCredentials ~= accountBlock["auth"]["username"].str();
        authenticationCredentials ~= accountBlock["auth"]["password"].str();

        /* Get the server (TODO: Key not found exception handling) */
        string server = accountBlock["server"].str();

        /* Generate the account */
        account = new Account(authenticationCredentials, server);

        return account;
    }
}