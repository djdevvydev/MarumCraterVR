using System;
using UnityEngine;

using System.Collections;
using Amazon.S3;
using Amazon;
using Amazon.S3.Model;
using System.Collections.Generic;
using System.IO;
using Amazon.CognitoIdentity;
using Amazon.Runtime;
using Amazon.S3.Util;
using Amazon.Unity3D;
using System.Net;

using System.Threading;

using System.Security.Cryptography;
using System.Text;

using System.Collections.Specialized;

public class ExportToAmazonScript : MonoBehaviour
{
    int numPolys = 0;

    private AmazonS3Client _S3Client = null;
    [HideInInspector]
    public string bucketName = "environments.altvr.com";
    [HideInInspector]
    public AWSRegion cognitoRegion = AWSRegion.USEast1;
    [HideInInspector]
    public AWSRegion s3Region = AWSRegion.USWest1;
    [HideInInspector]
    public string cognitoIdentityPool = "us-east-1:07ecd39f-7ec8-4d09-a833-640cdcd2ac20";
    private Dictionary<string, S3Object> unityPackagesLookup = null;
    private GameObject AWSPrefabGO = null;
    public string assetBundleName = "";
    [HideInInspector]
    public string assetBundlePath = "";
    
    //from AmazonInitializer
    private AmazonInitializer amazonInitializerInstance = null;
    private bool _initialized = false;
    private int MaxConnectionPoolSize = 10;
    [HideInInspector]
    public bool uploadLock = false;
    private string s3AssetKey = "";
    private AmazonS3Client S3Client
    {
        get 
        {
            if(_S3Client == null)
            {
                _S3Client = new AmazonS3Client (new CognitoAWSCredentials (cognitoIdentityPool,cognitoRegion.GetRegionEndpoint()),s3Region.GetRegionEndpoint());
            }
            return _S3Client;
        }
    }

    private void InitializeS3Client()
    {
        if (_S3Client == null)
        {
            CognitoAWSCredentials cognitoCred = new CognitoAWSCredentials(cognitoIdentityPool, cognitoRegion.GetRegionEndpoint());
            _S3Client = new AmazonS3Client(cognitoCred, s3Region.GetRegionEndpoint());

            //instantiate an AWSPrefab so we can access S3
            if (AWSPrefabGO == null)
            {
                AWSPrefabGO = (GameObject)Instantiate(Resources.Load<GameObject>("AWSPrefab"));
            }

            AmazonInitializer curAI = AWSPrefabGO.GetComponent<AmazonInitializer>();
            if (amazonInitializerInstance == null)
            {
                amazonInitializerInstance = curAI;
                // preventing the instance from getting destroyed between scenes
                DontDestroyOnLoad(curAI);

                // load service endpoints from config file
                Amazon.RegionEndpoint.LoadEndpointDefinitions();

                // add other scripts
                if (amazonInitializerInstance.gameObject.GetComponent<AmazonMainThreadDispatcher>() == null)
                    amazonInitializerInstance.gameObject.AddComponent<AmazonMainThreadDispatcher>();
                if (amazonInitializerInstance.gameObject.GetComponent<AmazonNetworkStatusInfo>() == null)
                    amazonInitializerInstance.gameObject.AddComponent<AmazonNetworkStatusInfo>();

                // init done 
                AmazonInitializer._initialized = true;
            }

        }
    }

    void ListBucketCallback (AmazonServiceResult result)
    {

        if (result.Exception == null)
        {
            ListBucketsResponse response = result.Response as ListBucketsResponse;
            foreach (S3Bucket bucket in response.Buckets)
            {
                Debug.Log(bucket.BucketName);
            }
        }
        else
        {
            Debug.LogException (result.Exception);
            Debug.LogError ("ListBucket fail");
        }
    }

    void ListObjectsCallback(AmazonServiceResult result)
    {
        unityPackagesLookup = new Dictionary<string, S3Object>();
        if (result.Exception == null)
        {
            ListObjectsResponse response = result.Response as ListObjectsResponse;

            foreach (S3Object ob in response.S3Objects)
            {
                if (ob.Key.EndsWith(".unity3d"))
                {
                    unityPackagesLookup.Add(ob.Key, ob);
                }
            }
        }
        else
        {
            Debug.LogException(result.Exception);
            string error = "Could not list unity files on " + bucketName + " bucket.  (ListObjects fail.)";
            Debug.LogError(error);
        }

        foreach (string key in unityPackagesLookup.Keys)
        {
            Debug.Log(key);
        }
    
    }

    public int getTotalNumPolys()
    {
        numPolys = 0;
        MeshFilter[] allMeshFilters = FindObjectsOfType<MeshFilter>();
        foreach (MeshFilter mf in allMeshFilters)
        {
            int tmpCount = mf.sharedMesh.triangles.Length / 3;
            //Debug.Log(mf.gameObject);
            //*mf.gameObject.renderer.sharedMaterials.Length;
            //Debug.Log("before: " + tmpCount.ToString() + ", after: " + (tmpCount/mf.gameObject.renderer.sharedMaterials.Length).ToString());
            numPolys += tmpCount;
        }
        Debug.Log("num polys: " + numPolys.ToString());
        return numPolys;
    }

    public void upload(string filePathToUpload)
    {
        uploadLock = true;
        string assetBundlePath = Directory.GetCurrentDirectory() +
                                     Path.DirectorySeparatorChar +
                                     filePathToUpload;

        Debug.Log("About to upload:" + assetBundlePath);

        //polys
        /*
        getTotalNumPolys();

        if (numPolys > 50000)
        {
            Debug.LogWarning("Poly count is over 50000!: " + numPolys);
        }
        else if (numPolys > 30000)
        {
            Debug.LogWarning("Poly count is over 30000!: " + numPolys);
        }
        */

        //do S3 stuff
        InitializeS3Client();

        //list buckets
        /*
        ListBucketsRequest request = new ListBucketsRequest();
        _S3Client.ListBucketsAsync(request, ListBucketCallback, null);

        //get existing *.unity3d files in assets.altvr.com bucket
        ListObjectsRequest listObjRequest = new ListObjectsRequest();
        listObjRequest.BucketName = bucketName;
        _S3Client.ListObjectsAsync(listObjRequest, ListObjectsCallback, null);
         */

        //upload
        Stream stream = null;
        try
        {
            stream = new FileStream(assetBundlePath, FileMode.Open, FileAccess.Read, FileShare.Read);
        }
        catch (IOException e)
        {
            Debug.LogException(e);
            Debug.LogError("Error trying to open filestream for: " + assetBundlePath);
            return;
        }

        s3AssetKey = generateS3AssetKey(assetBundleName);
        var postRequest = new PostObjectRequest
        {
            Key = s3AssetKey,
            Bucket = bucketName,
            InputStream = stream,
            Region = s3Region.GetRegionEndpoint(),
            CannedACL = S3CannedACL.PublicRead,
        };
        _S3Client.PostObjectAsync(postRequest, UploadAssetBundleCallback, null);
    }

    string generateS3AssetKey(string assetBundleName)
    {
        //generate SHA
        SHA256Managed hash = new SHA256Managed();
        byte[] bytes = Encoding.UTF8.GetBytes(DateTime.Now.ToString("yyyyMMddHHmmssfff"));
        string hashedString = HexStringFromBytes(hash.ComputeHash(bytes));
        string assetKey = "environments/" + assetBundleName + 
                          "/" + hashedString.Substring(0, 2) + "/" + hashedString.Substring(2, 2) + 
                          "/" + assetBundleName + "-" + hashedString + ".unity3d";
        return assetKey;
    }

    string HexStringFromBytes(byte[] bytes)
    {
        StringBuilder sb = new StringBuilder();
        foreach (byte b in bytes)
        {
            sb.Append(b.ToString("x2"));
        }
        return sb.ToString();
    }

    void UploadAssetBundleCallback(AmazonServiceResult result)
    {
        if (result.Exception == null)
        {
            //no info here - boooo
            /*
            S3PostUploadResponse response = result.Response as S3PostUploadResponse;
            Debug.Log(response.ResponseMetadata);
            Debug.Log(response.ContentLength);
            Debug.Log(response.HostId);
            Debug.Log(response.HttpStatusCode);
            Debug.Log(response.RequestId);
            Debug.Log(response.StatusCode);
            Debug.Log(response.ErrorMsg);
             */

            //post to rails endpoint
            //string url = "http://assets.altvr.com/environments/" + s3AssetKey;
            string url = "https://dc1gsc5wc5y2l.cloudfront.net/" + s3AssetKey;
            Debug.Log("uploaded: " + url);
            
            MakePostRequest(url);
        }
        else
        {
            Debug.Log(result.Exception.Data);
            Debug.Log(result.Exception.Message);
            Debug.LogException(result.Exception);
            string error = "Encountered error trying to upload " + Path.GetFileName(assetBundlePath) + " to " + bucketName + " bucket.";
            Debug.LogError(error);
        }

        uploadLock = false;
    }

    private string GetAuthData()
    {
        string authFilePath = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory) + Path.DirectorySeparatorChar + "altvrEnvirAccount";
        if(!File.Exists(authFilePath)){
            Debug.LogError("Authentication data not found.  Ask for the altvrEnvirAccount file to put on your desktop!");
            StopPlaying();
        }

        try
        {
            using (StreamReader sr = new StreamReader(authFilePath))
            {
                return sr.ReadToEnd();
            }
        }
        catch (Exception e)
        {
            Console.WriteLine("The file could not be read:");
            Console.WriteLine(e.Message);
            StopPlaying();
        }

        return "";
    }

    private void MakePostRequest(string assetBundleUrl)
    {
        string uri = "https://account.altvr.com/api/environment_asset_bundles";
        WWWForm form = new WWWForm();
        form.AddField("environment_asset_bundle_url", assetBundleUrl);
        byte[] rawData = form.data;
        Dictionary<String, String> headers = form.headers;
        Debug.Log(GetAuthData());
        headers["Authorization"] = "Basic " + System.Convert.ToBase64String(System.Text.Encoding.ASCII.GetBytes(GetAuthData()));
        Debug.Log("authorization: ");
        Debug.Log(headers["Authorization"]);

        WWW www = new WWW(uri, rawData, headers);
        while (!www.isDone)
        {
        }

        Debug.Log(www.text);
        StopPlaying();
    }

    void StopPlaying()
    {
        #if UNITY_EDITOR
        if (UnityEditor.EditorApplication.isPlaying)
            UnityEditor.EditorApplication.isPlaying = false;
        #endif
    }
}


