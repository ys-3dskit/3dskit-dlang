/**
 * @file sslc.h
 * @brief SSLC(TLS) service. https://3dbrew.org/wiki/SSL_Services
 */

import ys3ds.ctru._3ds.types;

extern (C) @nogc nothrow:

/// sslc context.
struct sslcContext
{
    Handle servhandle; ///< Service handle.
    uint sslchandle; ///< SSLC handle.
    Handle sharedmem_handle;
}

enum SSLC_DefaultRootCert
{
    SSLC_DefaultRootCert_Nintendo_CA = 0x1, //"Nintendo CA"
    SSLC_DefaultRootCert_Nintendo_CA_G2 = 0x2, //"Nintendo CA - G2"
    SSLC_DefaultRootCert_Nintendo_CA_G3 = 0x3, //"Nintendo CA - G3"
    SSLC_DefaultRootCert_Nintendo_Class2_CA = 0x4, //"Nintendo Class 2 CA"
    SSLC_DefaultRootCert_Nintendo_Class2_CA_G2 = 0x5, //"Nintendo Class 2 CA - G2"
    SSLC_DefaultRootCert_Nintendo_Class2_CA_G3 = 0x6, //"Nintendo Class 2 CA - G3"
    SSLC_DefaultRootCert_CyberTrust = 0x7, //"GTE CyberTrust Global Root"
    SSLC_DefaultRootCert_AddTrust_External_CA = 0x8, //"AddTrust External CA Root"
    SSLC_DefaultRootCert_COMODO = 0x9, //"COMODO RSA Certification Authority"
    SSLC_DefaultRootCert_USERTrust = 0xA, //"USERTrust RSA Certification Authority"
    SSLC_DefaultRootCert_DigiCert_EV = 0xB //"DigiCert High Assurance EV Root CA"
}

enum SSLC_DefaultClientCert
{
    SSLC_DefaultClientCert_ClCertA = 0x40
}

/// sslc options. https://www.3dbrew.org/wiki/SSL_Services#SSLOpt
enum
{
    SSLCOPT_Default = 0,
    SSLCOPT_DisableVerify = BIT(9), // "Disables server cert verification when set."
    SSLCOPT_TLSv10 = BIT(11) // "Use TLSv1.0."
}

/// Initializes SSLC. Normally session_handle should be 0. When non-zero this will use the specified handle for the main-service-session without using the Initialize command, instead of using srvGetServiceHandle.
Result sslcInit (Handle session_handle);

/// Exits SSLC.
void sslcExit ();

/**
 * @brief Creates a RootCertChain.
 * @param RootCertChain_contexthandle Output contexthandle.
 */
Result sslcCreateRootCertChain (uint* RootCertChain_contexthandle);

/**
 * @brief Destroys a RootCertChain.
 * @param RootCertChain_contexthandle RootCertChain contexthandle.
 */
Result sslcDestroyRootCertChain (uint RootCertChain_contexthandle);

/**
 * @brief Adds a trusted RootCA cert to a RootCertChain.
 * @param RootCertChain_contexthandle RootCertChain to use.
 * @param cert Pointer to the DER cert.
 * @param certsize Size of the DER cert.
 */
Result sslcAddTrustedRootCA (uint RootCertChain_contexthandle, const(ubyte)* cert, uint certsize, uint* cert_contexthandle);

/**
 * @brief Adds a default RootCA cert to a RootCertChain.
 * @param RootCertChain_contexthandle RootCertChain to use.
 * @param certID ID of the cert to add.
 * @param cert_contexthandle Optional, the cert contexthandle can be written here.
 */
Result sslcRootCertChainAddDefaultCert (uint RootCertChain_contexthandle, SSLC_DefaultRootCert certID, uint* cert_contexthandle);

/**
 * @brief Removes the specified cert from the RootCertChain.
 * @param RootCertChain_contexthandle RootCertChain to use.
 * @param cert_contexthandle Cert contexthandle to remove from the RootCertChain.
 */
Result sslcRootCertChainRemoveCert (uint RootCertChain_contexthandle, uint cert_contexthandle);

/**
 * @brief Creates an unknown CertChain.
 * @param CertChain_contexthandle Output contexthandle.
 */
Result sslcCreate8CertChain (uint* CertChain_contexthandle);

/**
 * @brief Destroys a CertChain from sslcCreate8CertChain().
 * @param CertChain_contexthandle CertChain contexthandle.
 */
Result sslcDestroy8CertChain (uint CertChain_contexthandle);

/**
 * @brief Adds a cert to a CertChain from sslcCreate8CertChain().
 * @param CertChain_contexthandle CertChain to use.
 * @param cert Pointer to the cert.
 * @param certsize Size of the cert.
 */
Result sslc8CertChainAddCert (uint CertChain_contexthandle, const(ubyte)* cert, uint certsize, uint* cert_contexthandle);

/**
 * @brief Adds a default cert to a CertChain from sslcCreate8CertChain(). Not actually usable since no certIDs are implemented in SSL-module for this.
 * @param CertChain_contexthandle CertChain to use.
 * @param certID ID of the cert to add.
 * @param cert_contexthandle Optional, the cert contexthandle can be written here.
 */
Result sslc8CertChainAddDefaultCert (uint CertChain_contexthandle, ubyte certID, uint* cert_contexthandle);

/**
 * @brief Removes the specified cert from the CertChain from sslcCreate8CertChain().
 * @param CertChain_contexthandle CertChain to use.
 * @param cert_contexthandle Cert contexthandle to remove from the CertChain.
 */
Result sslc8CertChainRemoveCert (uint CertChain_contexthandle, uint cert_contexthandle);

/**
 * @brief Opens a new ClientCert-context.
 * @param cert Pointer to the DER cert.
 * @param certsize Size of the DER cert.
 * @param key Pointer to the DER key.
 * @param keysize Size of the DER key.
 * @param ClientCert_contexthandle Output contexthandle.
 */
Result sslcOpenClientCertContext (const(ubyte)* cert, uint certsize, const(ubyte)* key, uint keysize, uint* ClientCert_contexthandle);

/**
 * @brief Opens a ClientCert-context with a default certID.
 * @param certID ID of the ClientCert to use.
 * @param ClientCert_contexthandle Output contexthandle.
 */
Result sslcOpenDefaultClientCertContext (SSLC_DefaultClientCert certID, uint* ClientCert_contexthandle);

/**
 * @brief Closes the specified ClientCert-context.
 * @param ClientCert_contexthandle ClientCert-context to use.
 */
Result sslcCloseClientCertContext (uint ClientCert_contexthandle);

/**
 * @brief This uses ps:ps SeedRNG internally.
 */
Result sslcSeedRNG ();

/**
 * @brief This uses ps:ps GenerateRandomData internally.
 * @param buf Output buffer.
 * @param size Output size.
 */
Result sslcGenerateRandomData (ubyte* buf, uint size);

/**
 * @brief Creates a sslc context.
 * @param context sslc context.
 * @param sockfd Socket fd, this code automatically uses the required SOC command before using the actual sslc command.
 * @param input_opt Input sslc options bitmask.
 * @param hostname Server hostname.
 */
Result sslcCreateContext (sslcContext* context, int sockfd, uint input_opt, const(char)* hostname);

/*
 * @brief Destroys a sslc context. The associated sockfd must be closed manually.
 * @param context sslc context.
 */
Result sslcDestroyContext (sslcContext* context);

/*
 * @brief Starts the TLS connection. If successful, this will not return until the connection is ready for data-transfer via sslcRead/sslcWrite.
 * @param context sslc context.
 * @param internal_retval Optional ptr where the internal_retval will be written. The value is only copied to here by this function when no error occurred.
 * @param out Optional ptr where an output u32 will be written. The value is only copied to here by this function when no error occurred.
 */
Result sslcStartConnection (sslcContext* context, int* internal_retval, uint* out_);

/*
 * @brief Receive data over the network connection.
 * @param context sslc context.
 * @param buf Output buffer.
 * @param len Size to receive.
 * @param peek When true, this is equivalent to setting the recv() MSG_PEEK flag.
 * @return When this isn't an error-code, this is the total transferred data size.
 */
Result sslcRead (sslcContext* context, void* buf, size_t len, bool peek);

/*
 * @brief Send data over the network connection.
 * @param context sslc context.
 * @param buf Input buffer.
 * @param len Size to send.
 * @return When this isn't an error-code, this is the total transferred data size.
 */
Result sslcWrite (sslcContext* context, const(void)* buf, size_t len);

/*
 * @brief Set the RootCertChain for the specified sslc context.
 * @param context sslc context.
 * @param handle RootCertChain contexthandle.
 */
Result sslcContextSetRootCertChain (sslcContext* context, uint handle);

/*
 * @brief Set the ClientCert-context for the specified sslc context.
 * @param context sslc context.
 * @param handle ClientCert contexthandle.
 */
Result sslcContextSetClientCert (sslcContext* context, uint handle);

/*
 * @brief Set the context for a CertChain from sslcCreate8CertChain(), for the specified sslc context. This needs updated once it's known what this context is for.
 * @param context sslc context.
 * @param handle contexthandle.
 */
Result sslcContextSetHandle8 (sslcContext* context, uint handle);

/*
 * @brief Clears the options field bits for the context using the specified bitmask.
 * @param context sslc context.
 * @param bitmask opt bitmask.
 */
Result sslcContextClearOpt (sslcContext* context, uint bitmask);

/*
 * @brief This copies two strings from context state to the specified output buffers. Each string is only copied if it was successfully loaded. The maxsizes include the nul-terminator. This can only be used if sslcStartConnection() was already used successfully.
 * @param context sslc context.
 * @param outprotocols Output buffer for a string containing all protocol versions supported by SSL-module.
 * @param outprotocols_maxsize Max size of the above output buffer.
 * @param outcipher Output buffer for a string containing the cipher suite currently being used.
 * @param outcipher_maxsize Max size of the above output buffer.
 */
Result sslcContextGetProtocolCipher (sslcContext* context, char* outprotocols, uint outprotocols_maxsize, char* outcipher, uint outcipher_maxsize);

/*
 * @brief This loads an u32 from the specified context state. This needs updated once it's known what this field is for.
 * @param context sslc context.
 * @param out Output ptr to write the value to.
 */
Result sslcContextGetState (sslcContext* context, uint* out_);

/*
 * @brief This initializes sharedmem for the specified context.
 * @param context sslc context.
 * @param buf Sharedmem buffer with address aligned to 0x1000-bytes.
 * @param size Sharedmem size aligned to 0x1000-bytes.
 */
Result sslcContextInitSharedmem (sslcContext* context, ubyte* buf, uint size);

/*
 * @brief This loads the specified cert. This needs updated once it's known what the cert format is and what the cert is used for later.
 * @param buf Input cert.
 * @param size Cert size.
 */
Result sslcAddCert (sslcContext* context, const(ubyte)* buf, uint size);
