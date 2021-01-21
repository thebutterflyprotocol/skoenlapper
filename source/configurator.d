module skoenlapper.configurator;

import std.json;
import gogga;
import std.stdio;
import std.socket : parseAddress, Address;
import std.string : split;
import std.conv : to;

public final class Configuration
{

    private Account[] accounts;
    
    this(JSONValue json)
    {
        /* Get each account */
        //JSONValue[] accountJSON = ["active"].array();

accounts = Account.getAccounts(json["accounts"]);

        // foreach(JSONValue account; accountJSON)
        // {
        //     /* Get the active account's name (TODO: Key not found) */
        //     string accountName = account.str();

        //     /* Get ther account block */
        //     JSONValue accountBlock = json["accounts"][accountName];

        //     /* Generate the account info */
        //     string username = accountBlock["auth"]["username"].str();
        //     string password = accountBlock["auth"]["password"].str();
        //     string server = accountBlock["server"].str();
        //     accounts ~= new Account([username, password], server);
        // }
    }

    public Account getAccount(ulong index)
    {
        return accounts[index];
    }
}

public JSONValue getConfiguration()
{
    /* The JSON configuration file */
    JSONValue config;

    /* Read the configuration file */
    File configFile;
    /* TODO: Change this later */
    configFile.open("/home/deavmi/.config/butterfly/butterfly.json", "rb");
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
    private string mailbox;

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

    public Address getServer()
    {
        return parseAddress(split(server, ":")[0], to!(ushort)(split(server, ":")[1]));
    }

    public string getMailbox()
    {
        return mailbox;
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
        writeln("FUCKING VAGINOSIS");

        /* Get the server (TODO: Key not found exception handling) */
        string server = accountBlock["server"].str();

        /* Generate the account */
        account = new Account(authenticationCredentials, server);

        /* Set the mailbox */
        account.mailbox = accountBlock["mailDirectory"].str();
        gprintln(accountBlock["mailDirectory"].str());
        writeln("Bruh: " ~account.mailbox);

        return account;
    }
}