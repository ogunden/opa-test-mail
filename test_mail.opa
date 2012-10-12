import stdlib.web.mail
import stdlib.web.mail.smtp.client

function email_of_address(address) {
    {name : {none}, ~address}
}

function send() {
  from_email =
    email_of_address(
      {local : "ogunden", domain : "phauna.org"});
  to_email =
    {local : "ogunden",
      domain : "gmail.com"};
  message = {
    subject: "the subject is",
    content: { html: <>"the content is uber"</> }
  }
  options = {Email.default_options
    with via : {some:"localhost"}
  };
  status = SmtpClient.try_send(
    from_email,
    email_of_address(to_email),
    message.subject,
    message.content,
    options
  );
  text = match (status) {
    case { bad_sender }: "bad sender"
    case { bad_recipient }: "bad recip"
    case { sending }: "sending"
    case { ~ok }: "ok: " ^ ok
    case { ~error }: "error: " ^ error
  };
  Resource.raw_text(text)
}

Uri.relative -> resource function start(uri) {
  match (uri.path) {
    | ["send"]     : send()
    | _ : send()
  }
}

Server.start(Server.http,
  { dispatch: start }
)
