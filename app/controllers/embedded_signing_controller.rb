class EmbeddedSigningController < ApplicationController

  def build_envelope(pdf_filename)
    envelope_definition = DocuSign_eSign::EnvelopeDefinition.new
    envelope_definition.email_subject = 'Please sign this document sent from Ruby SDK'
    doc = DocuSign_eSign::Document.new

    doc.document_base64 = Base64.encode64(File.binread(File.join('data', pdf_filename)))
    doc.name = 'Lorem Ipsum'
    doc.file_extension = 'pdf'
    doc.document_id = '2'

    envelope_definition.documents = [doc]
    envelope_definition.status = 'sent'
    envelope_definition
  end

  def build_signer(envelope_definition, signer_email, signer_name, signer_id)
    signer = DocuSign_eSign::Signer.new({
      email: signer_email,
      name: signer_name,
      clientUserId: signer_id,
      recipientId: signer_id,
      routingOrder: 0
    })
    recipients = envelope_definition.recipients
    if recipients.present?
      recipients.signers << signer
    else
      recipients = DocuSign_eSign::Recipients.new
      recipients.signers = [signer]
      envelope_definition.recipients = recipients
    end
    signer
  end

  def build_sign(signer, x, y)
    sign_here = DocuSign_eSign::SignHere.new({
      documentId: '2',
      pageNumber: '1',
      recipentId: signer.client_user_id,
      tabLabel: 'SignHere',
      xPosition: '195',
      yPosition: '147',
    })
    signer.tabs = DocuSign_eSign::Tabs.new({signHereTabs: [sign_here]})
    sign_here
  end

  def init_envelope
    access_token = 'eyJ0eXAiOiJNVCIsImFsZyI6IlJTMjU2Iiwia2lkIjoiNjgxODVmZjEtNGU1MS00Y2U5LWFmMWMtNjg5ODEyMjAzMzE3In0.AQoAAAABAAUABwCA7HpJcN7WSAgAgCyeV7Pe1kgCAKsZBs9RSxNPgv5x1_3YGSAVAAEAAAAYAAkAAAAFAAAAKwAAAC0AAAAvAAAAMQAAADIAAAA4AAAAMwAAADUAAAANACQAAABmMGYyN2YwZS04NTdkLTRhNzEtYTRkYS0zMmNlY2FlM2E5NzgSAAEAAAALAAAAaW50ZXJhY3RpdmUwAABW4khw3tZINwDJqZl5AmSpSpeEeFrVSdWh.uk6XpN_yB3IZ7EabT5B328zA2GhYKeuNQM50bmQOY2XylI6auXqz876zgYcplP5BnjTs6oGMabIn2SmnpzNMrF0D4nZ0XDGqvtUf_KNul209o-ZVqL5AeUPhKlXAZP2NPVwf-02UDq3I95fmjW_BYg8I5kwlRHgSLSzW7eGKr3iUal7Uf3q2Eq2vBRPI1XrKbjT7SoabGJ_mbequvgcR7d8Y8KWClRVk2TnULY18blPjSakqqjsI_u0KyvK62m4pmLSrAXiO1rKk0Rmhs4Px4e1YxGR36xD9L_3zT_dtVKZ4FV1V6fOVV_aaa8AR1dJMIQFidcHOaacvAMci8gOmnQ'
    account_id = '8289969'
    base_path = 'http://demo.docusign.net/restapi'

    envelope_definition = build_envelope("World_Wide_Corp_lorem.pdf")
    signer1 = build_signer(envelope_definition, "abhishek@synup.com", "Abhishek", 1)
    build_sign(signer1, 10, 10)

    signer2 = build_signer(envelope_definition, "binod@synup.com", "Binod", 2)
    build_sign(signer2, 30, 10)

    configuration = DocuSign_eSign::Configuration.new
    configuration.host = base_path
    api_client = DocuSign_eSign::ApiClient.new configuration
    api_client.default_headers["Authorization"] = "Bearer " + access_token
    envelopes_api = DocuSign_eSign::EnvelopesApi.new api_client

    results = envelopes_api.create_envelope account_id, envelope_definition
    results.envelope_id
  end

  def create
    base_url = request.base_url
    access_token = 'eyJ0eXAiOiJNVCIsImFsZyI6IlJTMjU2Iiwia2lkIjoiNjgxODVmZjEtNGU1MS00Y2U5LWFmMWMtNjg5ODEyMjAzMzE3In0.AQoAAAABAAUABwCA7HpJcN7WSAgAgCyeV7Pe1kgCAKsZBs9RSxNPgv5x1_3YGSAVAAEAAAAYAAkAAAAFAAAAKwAAAC0AAAAvAAAAMQAAADIAAAA4AAAAMwAAADUAAAANACQAAABmMGYyN2YwZS04NTdkLTRhNzEtYTRkYS0zMmNlY2FlM2E5NzgSAAEAAAALAAAAaW50ZXJhY3RpdmUwAABW4khw3tZINwDJqZl5AmSpSpeEeFrVSdWh.uk6XpN_yB3IZ7EabT5B328zA2GhYKeuNQM50bmQOY2XylI6auXqz876zgYcplP5BnjTs6oGMabIn2SmnpzNMrF0D4nZ0XDGqvtUf_KNul209o-ZVqL5AeUPhKlXAZP2NPVwf-02UDq3I95fmjW_BYg8I5kwlRHgSLSzW7eGKr3iUal7Uf3q2Eq2vBRPI1XrKbjT7SoabGJ_mbequvgcR7d8Y8KWClRVk2TnULY18blPjSakqqjsI_u0KyvK62m4pmLSrAXiO1rKk0Rmhs4Px4e1YxGR36xD9L_3zT_dtVKZ4FV1V6fOVV_aaa8AR1dJMIQFidcHOaacvAMci8gOmnQ'
    account_id = '8289969'

    signer_name = 'Abhishek'
    signer_email = 'abhishek@synup.com'
    signer_id = 1

    base_path = 'http://demo.docusign.net/restapi'

    authentication_method = 'None'
    configuration = DocuSign_eSign::Configuration.new
    configuration.host = base_path
    api_client = DocuSign_eSign::ApiClient.new configuration
    api_client.default_headers["Authorization"] = "Bearer " + access_token

    # Step 3. create the recipient view request for the Signing Ceremony
    view_request =  DocuSign_eSign::RecipientViewRequest.new
    # Set the url where you want the recipient to go once they are done signing
    # should typically be a callback route somewhere in your app.
    view_request.return_url = base_url + '/ds_return'
    # How has your app authenticated the user? In addition to your app's
    # authentication, you can include authenticate steps from DocuSign.
    # Eg, SMS authentication
    view_request.authentication_method = authentication_method
    # Recipient information must match embedded recipient info
    # we used to create the envelope.
    view_request.email = signer_email
    view_request.user_name = signer_name
    view_request.client_user_id = signer_id

    configuration = DocuSign_eSign::Configuration.new
    configuration.host = base_path
    api_client = DocuSign_eSign::ApiClient.new configuration
    api_client.default_headers["Authorization"] = "Bearer " + access_token
    envelopes_api = DocuSign_eSign::EnvelopesApi.new api_client

    # Step 4. call the CreateRecipientView API
    results = envelopes_api.create_recipient_view account_id, "6abeaa31-3c38-4a64-ab96-49853e6bb930", view_request

    # Step 5. Redirect the user to the Signing Ceremony
    # Don't use an iFrame!
    # State can be stored/recovered using the framework's session or a
    # query parameter on the returnUrl (see the makeRecipientViewRequest method)
    redirect_to results.url

  rescue DocuSign_eSign::ApiError => e
    @error_msg = e.response_body
    render "welcome/error_return"
  end

  def index
  end
end
