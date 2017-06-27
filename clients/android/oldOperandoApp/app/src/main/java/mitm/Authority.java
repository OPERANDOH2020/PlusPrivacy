package mitm;


import android.content.Context;

import java.io.File;

/**
 * Parameter object holding personal informations given to a SSLEngineSource.
 * 
 * XXX consider to inline within the interface SslEngineSource, if MITM is core
 */
public class Authority {

    private final File keyStoreDir;

    private final String alias;

    private final char[] password;

    private final String commonName;

    private final String organization;

    private final String organizationalUnitName;

    private final String certOrganization;

    private final String certOrganizationalUnitName;

    private final String keyStoreProvider;

    private Context context;

    /**
     * Create a parameter object with example certificate and certificate
     * authority informations
     */
    public Authority(Context context) {
        this.context = context;
        keyStoreDir = new File(context.getCacheDir().getAbsolutePath());
        //new File(".");
        alias = "operando-mitm"; // proxy id
        password = "Be Your Own Lantern".toCharArray();
        organization = "OPERANDO PROJECT"; // proxy name
        commonName = organization; // MITM is bad
                                                             // normally
        organizationalUnitName = "Certificate Authority";
        certOrganization = organization; // proxy name
        certOrganizationalUnitName = "OPERANDO PROJECT";
//                organization
//                + ", describe proxy purpose here, since Man-In-The-Middle is bad normally.";
        keyStoreProvider = "BC";
    }

    public File aliasFile(String fileExtension) {
        return new File(keyStoreDir, alias + fileExtension);
    }

    public String alias() {
        return alias;
    }

    public char[] password() {
        return password;
    }

    public String commonName() {
        return commonName;
    }

    public String organization() {
        return organization;
    }

    public String organizationalUnitName() {
        return organizationalUnitName;
    }

    public String certOrganisation() {
        return certOrganization;
    }

    public String certOrganizationalUnitName() {
        return certOrganizationalUnitName;
    }

    public String keyStoreProvider() {
        return keyStoreProvider;
    }

    public File keyStoreDir() {
        return keyStoreDir;
    }

    public Context context() {
        return context;
    }
}
