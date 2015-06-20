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

using System.Globalization;
using System.IO;
using Amazon.Runtime.Internal;
using Amazon.Runtime.Internal.Auth;
using Amazon.Runtime.Internal.Transform;
using Amazon.Runtime.Internal.Util;
using Amazon.S3.Util;
using Amazon.Util;

namespace Amazon.S3.Model.Internal.MarshallTransformations
{
    /// <summary>
    /// Upload Part Request Marshaller
    /// </summary>       
    public class UploadPartRequestMarshaller : IMarshaller<IRequest, UploadPartRequest>
    {
        public IRequest Marshall(UploadPartRequest uploadPartRequest)
        {
            IRequest request = new DefaultRequest(uploadPartRequest, "AmazonS3");

            request.HttpMethod = "PUT";

            if (uploadPartRequest.IsSetMD5Digest())
                request.Headers[HeaderKeys.ContentMD5Header] = uploadPartRequest.MD5Digest;

            if (uploadPartRequest.IsSetServerSideEncryptionCustomerMethod())
                request.Headers.Add(HeaderKeys.XAmzSSECustomerAlgorithmHeader, uploadPartRequest.ServerSideEncryptionCustomerMethod);
            if (uploadPartRequest.IsSetServerSideEncryptionCustomerProvidedKey())
            {
                request.Headers.Add(HeaderKeys.XAmzSSECustomerKeyHeader, uploadPartRequest.ServerSideEncryptionCustomerProvidedKey);
                if (uploadPartRequest.IsSetServerSideEncryptionCustomerProvidedKeyMD5())
                    request.Headers.Add(HeaderKeys.XAmzSSECustomerKeyMD5Header, uploadPartRequest.ServerSideEncryptionCustomerProvidedKeyMD5);
                else
                    request.Headers.Add(HeaderKeys.XAmzSSECustomerKeyMD5Header, AmazonS3Util.ComputeEncodedMD5FromEncodedString(uploadPartRequest.ServerSideEncryptionCustomerProvidedKey));
            }

            request.ResourcePath = string.Format(CultureInfo.InvariantCulture, "/{0}/{1}",
                                                 S3Transforms.ToStringValue(uploadPartRequest.BucketName),
                                                 S3Transforms.ToStringValue(uploadPartRequest.Key));

            if (uploadPartRequest.IsSetPartNumber())
                request.AddSubResource("partNumber", S3Transforms.ToStringValue(uploadPartRequest.PartNumber));
            if (uploadPartRequest.IsSetUploadId())
                request.AddSubResource("uploadId", S3Transforms.ToStringValue(uploadPartRequest.UploadId));

            if (uploadPartRequest.InputStream != null)
            {
                // Wrap input stream in partial wrapper (to upload only part of the stream)
                var partialStream = new PartialWrapperStream(uploadPartRequest.InputStream, uploadPartRequest.PartSize);
                if (partialStream.Length > 0)
                    request.UseChunkEncoding = true;
                if (!request.Headers.ContainsKey(HeaderKeys.ContentLengthHeader))
                    request.Headers.Add(HeaderKeys.ContentLengthHeader, partialStream.Length.ToString(CultureInfo.InvariantCulture));

                // Wrap input stream in MD5Stream; after this we can no longer seek or position the stream
                var hashStream = new MD5Stream(partialStream, null, partialStream.Length);
                uploadPartRequest.InputStream = hashStream;
            }

            request.ContentStream = uploadPartRequest.InputStream;

            if (!request.Headers.ContainsKey(HeaderKeys.ContentTypeHeader))
                request.Headers.Add(HeaderKeys.ContentTypeHeader, "text/plain");

            return request;
        }
    }
}

