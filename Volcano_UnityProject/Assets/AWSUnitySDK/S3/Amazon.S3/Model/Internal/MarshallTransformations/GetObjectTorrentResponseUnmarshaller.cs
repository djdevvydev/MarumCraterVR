/*
 * Copyright 2014-2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 *
 * Licensed under the AWS Mobile SDK for Unity Developer Preview License Agreement (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located in the "license" file accompanying this file.
 * See the License for the specific language governing permissions and limitations under the License.
 *
 */
using System;
using System.Net;
using System.Collections.Generic;
using Amazon.S3.Model;
using Amazon.Runtime;
using Amazon.Runtime.Internal;
using Amazon.Runtime.Internal.Transform;

namespace Amazon.S3.Model.Internal.MarshallTransformations
{
    /// <summary>
    ///    Response Unmarshaller for GetObjectTorrent operation
    /// </summary>
    internal class GetObjectTorrentResponseUnmarshaller : S3ReponseUnmarshaller
    {
        public override AmazonWebServiceResponse Unmarshall(XmlUnmarshallerContext context) 
        {   
            GetObjectTorrentResponse response = new GetObjectTorrentResponse();
            
            UnmarshallResult(context,response);                        
                 
                        
            return response;
        }
        
        private static void UnmarshallResult(XmlUnmarshallerContext context,GetObjectTorrentResponse response)
        {
            
            response.ResponseStream = context.Stream;
                                        


            return;
        }
        
        internal override bool HasStreamingProperty
        {
           get { return true;}
        }
        
        public override AmazonServiceException UnmarshallException(XmlUnmarshallerContext context, Exception innerException, HttpStatusCode statusCode)
        {
            S3ErrorResponse errorResponse = S3ErrorResponseUnmarshaller.GetInstance().Unmarshall(context);

            return new AmazonS3Exception(errorResponse.Message, innerException, errorResponse.Type, errorResponse.Code, errorResponse.RequestId, statusCode, errorResponse.Id2);
        }
        
        private static GetObjectTorrentResponseUnmarshaller instance;

        public static GetObjectTorrentResponseUnmarshaller GetInstance()
        {
            if (instance == null) 
            {
               instance = new GetObjectTorrentResponseUnmarshaller();
            }
            return instance;
        }
    
    }
}
    
