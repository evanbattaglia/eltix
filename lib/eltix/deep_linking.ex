defmodule Eltix.DeepLinking do
  @expiry_time 600

  def deep_link_return_url(request_claims) do
    request_claims["https://purl.imsglobal.org/spec/lti-dl/claim/deep_linking_settings"]["deep_link_return_url"]
  end

  def build_response_jwt(request_claims, msg) do
    %{
      iss: request_claims["iss"],
      aud: request_claims["aud"],
      nonce: request_claims["nonce"],
      iat: :os.system_time(:millisecond),
      exp: :os.system_time(:millisecond) + @expiry_time,

      "https://purl.imsglobal.org/spec/lti/claim/message_type": "LtiDeepLinkingResponse",
      "https://purl.imsglobal.org/spec/lti/claim/version": "1.3.0",
      "https://purl.imsglobal.org/spec/lti/claim/deployment_id": request_claims["https://purl.imsglobal.org/spec/lti/claim/deployment_id"],
      "https://purl.imsglobal.org/spec/lti-dl/claim/content_items": [
        %{
          type: "link",
          url: "https://www.example.com/",
          title: "ELTIX IS THE BEST",
          text: "ELTIX IS THE BEST",
          icon: "https://via.placeholder.com/50?text=ELTIX+IS+DA+BOMB",
          thumbnail: "https://via.placeholder.com/250?text=ELTIX+IS+DA+BOMB",
        }
      ],
      "https://purl.imsglobal.org/spec/lti-dl/claim/msg": msg,
      "https://purl.imsglobal.org/spec/lti-dl/claim/errormsg": "",
      "https://purl.imsglobal.org/spec/lti-dl/claim/log": "",
      "https://purl.imsglobal.org/spec/lti-dl/claim/errorlog": ""
    }
  end

end
