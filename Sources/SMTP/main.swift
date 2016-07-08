/*
 SMTP Makes use of multiple RFC specs
 
 ESMTP
 https://tools.ietf.org/html/rfc1869#section-4.3
 SMTP
 https://tools.ietf.org/html/rfc5321#section-4.5.3.2
 
 AUTH
 https://tools.ietf.org/html/rfc821#page-4

 LEGACY - DO NOT SUPPORT
 https://tools.ietf.org/html/rfc821#page-4
 */

import Foundation

struct RFC1123 {
    static func now() -> String {
        return Date().rfc1123
    }

    static let shared = RFC1123()
    var formatter: DateFormatter

    init() {
        formatter = DateFormatter()
        formatter.locale = Locale(localeIdentifier: "en_US")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"
    }
}

extension Date {
    public var rfc1123: String {
        return RFC1123.shared.formatter.string(from: self)
    }
}


//print(RFC1123.now())
//print("")

//import Engine
//
//struct Email {
//    let sender: String
//    let recipients: [String]
//}
//
//let stream = try FoundationStream(host: "smtp.gmail.com", port: 465, securityLayer: .tls)
//let connection = try stream.connect()
//// 220 service ready greeting
//print(try connection.receive(max: 5000).string)
///*
// 220 smtp.gmail.com ESMTP p39sm303264qtp.14 - gsmtp
// */
//try connection.send("EHLO localhost \r\n")
//
///*
// https://tools.ietf.org/html/rfc5321#section-4.1.1.1
//
// 250-smtp.gmail.com at your service, [209.6.42.158]
// 250-SIZE 35882577
// 250-8BITMIME
// 250-AUTH LOGIN PLAIN XOAUTH2 PLAIN-CLIENTTOKEN OAUTHBEARER XOAUTH
// 250-ENHANCEDSTATUSCODES
// 250-PIPELINING
// 250-CHUNKING
// 250 SMTPUTF8
// 
// FINAL LINE IS `250` w/ NO `-`
// */
//print(try connection.receive(max: 5000).string)
//
//try connection.send("AUTH LOGIN\r\n")
//print(try connection.receive(max: 5000).string)
//try connection.send("vapor.smtptest@gmail.com".bytes.base64String + "\r\n")
//print(try connection.receive(max: 5000).string)
//try connection.send("vapor.test".bytes.base64String + "\r\n")
//print(try connection.receive(max: 5000).string)
//try connection.send("MAIL FROM:<vapor.smtptest@gmail.com> BODY=8BITMIME\r\n")
//print(try connection.receive(max: 5000).string)
//try connection.send("RCPT TO:<logan@qutheory.io> \r\n")
//print(try connection.receive(max: 5000).string)
//try connection.send("DATA\r\n")
//print(try connection.receive(max: 5000).string)
///*
// C: Date: Thu, 21 May 1998 05:33:22 -0700
// C: From: John Q. Public <JQP@bar.com>
// C: Subject:  The Next Meeting of the Board
// C: To: Jones@xyz.com
// */
//try connection.send("Subject: SMTP Subject Test\r\n")
//try connection.send("Hello from smtp")
//try connection.send("\r\n.\r\n")
//print(try connection.receive(max: 5000).string)
//try connection.send("QUIT\r\n")
//print(try connection.receive(max: 5000).string)
//print("SMTP")

import Engine

import Foundation

extension NSUUID {
    var messageId: String {
        return NSUUID().uuidString.components(separatedBy: "-").joined(separator: "")
    }
}

struct InternetMessage {
    /*
     to /
     cc /
     bcc /
     message-id /
     in-reply-to /
     references /
     subject /
     comments /
     keywords /
     optional-field)
     */
    let to: String
    let from: String
    let cc: [String]?
    let bcc: [String]?
    let id: String
    let replyToId: String?

}

/*
 Field           Min number      Max number      Notes

 trace           0               unlimited       Block prepended - see
 3.6.7

 resent-date     0*              unlimited*      One per block, required
 if other resent fields
 present - see 3.6.6

 resent-from     0               unlimited*      One per block - see
 3.6.6

 resent-sender   0*              unlimited*      One per block, MUST
 occur with multi-address
 resent-from - see 3.6.6

 resent-to       0               unlimited*      One per block - see
 3.6.6

 resent-cc       0               unlimited*      One per block - see
 3.6.6

 resent-bcc      0               unlimited*      One per block - see
 3.6.6

 resent-msg-id   0               unlimited*      One per block - see
 3.6.6

 orig-date       1               1

 from            1               1               See sender and 3.6.2



 Resnick                     Standards Track                    [Page 19]

 RFC 2822                Internet Message Format               April 2001


 sender          0*              1               MUST occur with multi-
 address from - see 3.6.2

 reply-to        0               1

 to              0               1

 cc              0               1

 bcc             0               1

 message-id      0*              1               SHOULD be present - see
 3.6.4

 in-reply-to     0*              1               SHOULD occur in some
 replies - see 3.6.4

 references      0*              1               SHOULD occur in some
 replies - see 3.6.4

 subject         0               1

 comments        0               unlimited

 keywords        0               unlimited

 optional-field  0               unlimited
 */



/*
 There are two limits that this standard places on the number of
 characters in a line. Each line of characters MUST be no more than
 998 characters, and SHOULD be no more than 78 characters, excluding
 the CRLF.

 The 998 character limit is due to limitations in many implementations
 which send, receive, or store Internet Message Format messages that
 simply cannot handle more than 998 characters on a line. Receiving
 implementations would do well to handle an arbitrarily large number
 of characters in a line for robustness sake. However, there are so
 many implementations which (in compliance with the transport
 requirements of [RFC2821]) do not accept messages containing more
 than 1000 character including the CR and LF per line, it is important
 for implementations not to create such messages.

 The more conservative 78 character recommendation is to accommodate
 the many implementations of user interfaces that display these
 messages which may truncate, or disastrously wrap, the display of
 more than 78 characters per line, in spite of the fact that such
 implementations are non-conformant to the intent of this
 specification (and that of [RFC2821] if they actually cause
 information to be lost). Again, even though this limitation is put on
 messages, it is encumbant upon implementations which display messages





 Resnick                     Standards Track                     [Page 6]

 RFC 2822                Internet Message Format               April 2001


 to handle an arbitrarily large number of characters in a line
 (certainly at least up to the 998 character limit) for the sake of
 robustness.
 */

//DispatchQueue.global(attributes: .qosBackground).after(when: DispatchTime(30), execute: { })

// TODO: MUST TIMEOUT
/*
 
 // TODO: MUST TIMEOUT
 
 4.5.3.2.  Timeouts

 An SMTP client MUST provide a timeout mechanism.  It MUST use per-
 command timeouts rather than somehow trying to time the entire mail
 transaction.  Timeouts SHOULD be easily reconfigurable, preferably
 without recompiling the SMTP code.  To implement this, a timer is set
 for each SMTP command and for each buffer of the data transfer.  The
 latter means that the overall timeout is inherently proportional to
 the size of the message.

 Based on extensive experience with busy mail-relay hosts, the minimum
 per-command timeout values SHOULD be as follows:
 
 */

extension DispatchTime {

    static var fiveMinutes: DispatchTime {
        // TODO: Currently can only set distant future or now :( fix when foundation updates
        return DispatchTime.distantFuture
    }
}


final class TimeoutOperation {
    typealias Timeout = (TimeoutOperation) -> Void

    let label: String
    private var timeout: Timeout?

    init(label: String, duration: DispatchTime, timeout: Timeout, queue: DispatchQueue = DispatchQueue.global(attributes: .qosBackground)) {
        self.label = label
        self.timeout = timeout

        queue.after(when: duration) { [weak self] in
            guard let welf = self, let timeout = welf.timeout else {
                // cancelled -- ok
                return
            }
            timeout(welf)
        }
    }

    func cancel() {
        timeout = nil
    }
}

enum TimeoutError: ErrorProtocol {
    case timedOut
}

import Base
//
//func timingOut<T>(_ time: Double, operation: () throws -> T) throws -> T {
//    Promise<T>.async(timingOut: <#T##DispatchTime#>, <#T##handler: (Promise<T>) throws -> Void##(Promise<T>) throws -> Void#>)
////    DispatchQueue.global(attributes: .qosBackground)
//}


extension Promise {
    static func timeout(_ timingOut: DispatchTime, operation: () throws -> T) throws -> T {
        // TODO: async is locked, it needs to be something like `block` or `lockForAsync`
        return try Promise<T>.async(timingOut: timingOut) { promise in
            let value = try operation()
            promise.resolve(with: value)
        }
    }
}

/*
 https://tools.ietf.org/html/rfc1869#section-4.3

 4.3.  Successful response

 If the server SMTP implements and is able to perform the EHLO
 command, it will return code 250.  This indicates that both the
 server and client SMTP are in the initial state, that is, there is no
 transaction in progress and all state tables and buffers are cleared.

 Normally, this response will be a multiline reply. Each line of the
 response contains a keyword and, optionally, one or more parameters.
 The syntax for a positive response, using the ABNF notation of [2],
 is:

 ehlo-ok-rsp  ::=      "250"    domain [ SP greeting ] CR LF
 / (    "250-"   domain [ SP greeting ] CR LF
 *( "250-"      ehlo-line           CR LF )
 "250"    SP ehlo-line           CR LF   )

 ; the usual HELO chit-chat
 greeting     ::= 1*<any character other than CR or LF>

 ehlo-line    ::= ehlo-keyword *( SP ehlo-param )

 ehlo-keyword ::= (ALPHA / DIGIT) *(ALPHA / DIGIT / "-")

 ; syntax and values depend on ehlo-keyword
 ehlo-param   ::= 1*<any CHAR excluding SP and all
 control characters (US ASCII 0-31
 inclusive)>

 ALPHA        ::= <any one of the 52 alphabetic characters
 (A through Z in upper case, and,
 a through z in lower case)>
 DIGIT        ::= <any one of the 10 numeric characters
 (0 through 9)>

 CR           ::= <the carriage-return character
 (ASCII decimal code 13)>
 LF           ::= <the line-feed character
 (ASCII decimal code 10)>
 */
final class SMTPResponse {
    let replyCode: Int
    let domain: String
    let greeting: String?

    private(set) var extensions: [String] = []
    private init(replyCode: Int, domain: String, greeting: String?) {
        self.replyCode = replyCode
        self.domain = domain
        self.greeting = greeting
    }
}

final class ReplyAggregator {
//    private
    private(set) var complete: Bool = false
    init() {}

    func process(line: Bytes) throws {
    }
}

extension String {
    var int: Int? {
        return Int(self)
    }
}

extension Collection {
    public subscript(safe idx: Index) -> Iterator.Element? {
        guard startIndex <= idx else { return nil }
        // NOT >=, endIndex is "past the end"
        guard endIndex > idx else { return nil }
        return self[idx]
    }
}

enum SMTPClientError: ErrorProtocol {
    case initializationFailed(code: Int, greeting: String)
    case initializationFailed554(reason: String)
    case invalidMultilineReplyCode(expected: Int, got: Int)
    case invalidEhloHeader
}

extension String: ErrorProtocol {}
import Base

private let crlf: Bytes = [.carriageReturn, .newLine]

struct SMTPExtension {

}

struct SMTPHeader {
    let domain: String
    let greeting: String

    private init(_ line: String) throws {
        let split = line
            .bytes
            .split(separator: .space, maxSplits: 1)
            .map { $0.string }
        guard split.count >= 1 else { throw "must at least have domain" }
        domain = split[0]
        greeting = split[safe: 1] ?? ""
    }
}

/*
 ehlo-line    ::= ehlo-keyword *( SP ehlo-param )
 */
struct EHLOExtension {
    let keyword: String
    let params: [String]

    init(_ line: String) throws {
        let args = line.components(separatedBy: " ")
        guard let keyword = args.first else { throw "missing keyword" }
        self.keyword = keyword
        self.params = args.dropFirst().array // rm keyword
    }
}

/*
 Timeouts - https://tools.ietf.org/html/rfc5321#section-4.5.3.2
 */
final class SMTPClient<ClientStreamType: ClientStream>: ProgramStream {
    let host: String
    let port: Int
    let securityLayer: SecurityLayer

    let stream: Engine.Stream

    init(host: String, port: Int, securityLayer: SecurityLayer) throws {
        self.host = host
        self.port = port
        self.securityLayer  = securityLayer

        let client = try ClientStreamType(host: host, port: port, securityLayer: securityLayer)
        self.stream = try client.connect()
    }

    deinit {
        if !stream.closed {
            _ = try? stream.close()
        }
    }

    func send() throws {
        try Promise.timeout(.fiveMinutes, operation: initializeSession)
        // TODO: Should default to localhost?
        let (header, extensions) = try initiate(fromDomain: "localhost")

        // TODO: localhost?
//        let (initiateCode, replies) = try initiate(currentHost: "localhost")
        print("[initiated] \(header)")
        print("[initiated] \n\t\(extensions.map({"\($0)"}).joined(separator: "\n\t"))")
        print("")
    }

    /*
     4.5.3.2.1.  Initial 220 Message: 5 Minutes

     An SMTP client process needs to distinguish between a failed TCP
     connection and a delay in receiving the initial 220 greeting message.
     Many SMTP servers accept a TCP connection but delay delivery of the
     220 message until their system load permits more mail to be
     processed.
     */


    /*
     https://tools.ietf.org/html/rfc5321#section-3.1

     3.1.  Session Initiation

     An SMTP session is initiated when a client opens a connection to a
     server and the server responds with an opening message.

     SMTP server implementations MAY include identification of their
     software and version information in the connection greeting reply
     after the 220 code, a practice that permits more efficient isolation
     and repair of any problems.  Implementations MAY make provision for
     SMTP servers to disable the software and version announcement where
     it causes security concerns.  While some systems also identify their
     contact point for mail problems, this is not a substitute for
     maintaining the required "postmaster" address (see Section 4).

     The SMTP protocol allows a server to formally reject a mail session
     while still allowing the initial connection as follows: a 554
     response MAY be given in the initial connection opening message
     instead of the 220.  A server taking this approach MUST still wait
     for the client to send a QUIT (see Section 4.1.1.10) before closing
     the connection and SHOULD respond to any intervening commands with
     "503 bad sequence of commands".  Since an attempt to make an SMTP
     connection to such a system is probably in error, a server returning
     a 554 response on connection opening SHOULD provide enough
     information in the reply text to facilitate debugging of the sending
     system.

     */
    private func initializeSession() throws {
        let (replyCode, greeting, isLast) = try acceptReplyLine()
        print("[initialized] \(replyCode) \(greeting)")
        // initialization should be single line w/ 220
        if isLast && replyCode == 220 { return }
        else {
            try quit()
            throw SMTPClientError.initializationFailed(code: replyCode, greeting: greeting)
        }
    }

    /*
     https://tools.ietf.org/html/rfc5321#section-3.2

     3.2.  Client Initiation

     Once the server has sent the greeting (welcoming) message and the
     client has received it, the client normally sends the EHLO command to
     the server, indicating the client's identity.  In addition to opening
     the session, use of EHLO indicates that the client is able to process
     service extensions and requests that the server provide a list of the
     extensions it supports.  Older SMTP systems that are unable to
     support service extensions, and contemporary clients that do not
     require service extensions in the mail session being initiated, MAY
     use HELO instead of EHLO.  Servers MUST NOT return the extended EHLO-
     style response to a HELO command.  For a particular connection
     attempt, if the server returns a "command not recognized" response to
     EHLO, the client SHOULD be able to fall back and send HELO.

     In the EHLO command, the host sending the command identifies itself;
     the command may be interpreted as saying "Hello, I am <domain>" (and,
     in the case of EHLO, "and I support service extension requests").
     
     4.5.  Error responses from extended servers

     If the server SMTP recognizes the EHLO command, but the command
     argument is unacceptable, it will return code 501.

     If the server SMTP recognizes, but does not implement, the EHLO
     command, it will return code 502.

     If the server SMTP determines that the SMTP service is no longer
     available (e.g., due to imminent system shutdown), it will return
     code 421.

     In the case of any error response, the client SMTP should issue
     either the HELO or QUIT command.

     4.6.  Responses from servers without extensions

     A server SMTP that conforms to RFC 821 but does not support the
     extensions specified here will not recognize the EHLO command and
     will consequently return code 500, as specified in RFC 821.  The
     server SMTP should stay in the same state after returning this code
     (see section 4.1.1 of RFC 821).  The client SMTP may then issue
     either a HELO or a QUIT command.
     */


    /*
     https://tools.ietf.org/html/rfc1869#section-4.3

     4.3.  Successful response

     If the server SMTP implements and is able to perform the EHLO
     command, it will return code 250.  This indicates that both the
     server and client SMTP are in the initial state, that is, there is no
     transaction in progress and all state tables and buffers are cleared.

     Normally, this response will be a multiline reply. Each line of the
     response contains a keyword and, optionally, one or more parameters.
     The syntax for a positive response, using the ABNF notation of [2],
     is:

     ehlo-ok-rsp  ::=      "250"    domain [ SP greeting ] CR LF
     / (    "250-"   domain [ SP greeting ] CR LF
     *( "250-"      ehlo-line           CR LF )
     "250"    SP ehlo-line           CR LF   )

     ; the usual HELO chit-chat
     greeting     ::= 1*<any character other than CR or LF>

     ehlo-line    ::= ehlo-keyword *( SP ehlo-param )

     ehlo-keyword ::= (ALPHA / DIGIT) *(ALPHA / DIGIT / "-")

     ; syntax and values depend on ehlo-keyword
     ehlo-param   ::= 1*<any CHAR excluding SP and all
     control characters (US ASCII 0-31
     inclusive)>

     ALPHA        ::= <any one of the 52 alphabetic characters
     (A through Z in upper case, and,
     a through z in lower case)>
     DIGIT        ::= <any one of the 10 numeric characters
     (0 through 9)>
     
     CR           ::= <the carriage-return character
     (ASCII decimal code 13)>
     LF           ::= <the line-feed character
     (ASCII decimal code 10)>
     */
    private func initiate(fromDomain: String = "localhost") throws -> (header: SMTPHeader, extensions: [EHLOExtension]) {
        try send(line: "EHLO \(fromDomain)")
        var (code, replies) = try acceptReply()
        /*
         The 500 response indicates that the server SMTP does
         not implement the extensions specified here.  The
         client would normally send a HELO command and proceed
         as specified in RFC 821.   See section 4.7 for
         additional discussion.
         */
        if code == 500 {
            try send(line: "HELO \(fromDomain)")
            (code, replies) = try acceptReply()
        }

        guard code == 250 else {
            /*
             In the case of any error response, the client SMTP should issue
             either the HELO or QUIT command.
             
             ^ we already tried HELO -- now we quit
             */
            _ = try? quit()
            throw "error initiating \(code)"
        }

        guard let header = try replies.first.flatMap(SMTPHeader.init) else { throw "response should have at least one line" }
        let extensions = try replies.dropFirst().map(EHLOExtension.init)
        return (header, extensions)
    }

    private func send(line: String) throws {
        try stream.send(line)
        try stream.send(crlf)
        try stream.flush()
    }

    /*
     The format for multiline replies requires that every line, except the
     last, begin with the reply code, followed immediately by a hyphen,
     "-" (also known as minus), followed by text.  The last line will
     begin with the reply code, followed immediately by <SP>, optionally
     some text, and <CRLF>.  As noted above, servers SHOULD send the <SP>
     if subsequent text is not sent, but clients MUST be prepared for it
     to be omitted.

     For example:

     250-First line
     250-Second line
     250-234 Text beginning with numbers
     250 The last line

     In a multiline reply, the reply code on each of the lines MUST be the
     same.  It is reasonable for the client to rely on this, so it can
     make processing decisions based on the code in any line, assuming
     that all others will be the same.  In a few cases, there is important
     data for the client in the reply "text".  The client will be able to
     identify these cases from the current context.
     */
    private func acceptReply() throws -> (replyCode: Int, replies: [String]) {
        // first
        let (replyCode, initialReply, isLast) = try acceptReplyLine()
        var finished = isLast

        var replies: [String] = [initialReply]
        while !finished {
            let (code, reply, done) = try acceptReplyLine()
            guard code == replyCode else { throw SMTPClientError.invalidMultilineReplyCode(expected: replyCode, got: code) }
            replies.append(reply)
            finished = done
        }

        return (replyCode, replies)
    }

    private func acceptReplyLine() throws -> (replyCode: Int, reply: String, isLast: Bool) {
        let line = try stream.receiveLine()
        let replyCode = line.prefix(3).string.int ?? -1
        let token = line[safe: 3] // 0,1,2 == Status Code 3 is hyphen if should continue
        let reply = line.dropFirst(4).string
        // hyphen indicates continue, SHOULD send space, but doesn't have to
        // any NON-hyphen == last
        return (replyCode, reply, token != .hyphen)
    }

    private func quit() throws {
        try stream.send("QUIT".bytes + crlf)
    }
}


func originalWorkingSave() throws {
    // MARK: WORKING

    /*
     Ports
     Use port 25, 2525, or 587 for unencrypted / TLS connections
     Use port 465 for SSL connections
     */
    let stream = try FoundationStream(host: "smtp.sendgrid.net", port: 465, securityLayer: .tls)
    let connection = try stream.connect()
    // 220 service ready greeting
    print(try connection.receive(max: 5000).string)
    /*
     220 smtp.gmail.com ESMTP p39sm303264qtp.14 - gsmtp
     */
    try connection.send("EHLO localhost \r\n")

    /*
     https://tools.ietf.org/html/rfc5321#section-4.1.1.1

     250-smtp.gmail.com at your service, [209.6.42.158]
     250-SIZE 35882577
     250-8BITMIME
     250-AUTH LOGIN PLAIN XOAUTH2 PLAIN-CLIENTTOKEN OAUTHBEARER XOAUTH
     250-ENHANCEDSTATUSCODES
     250-PIPELINING
     250-CHUNKING
     250 SMTPUTF8

     FINAL LINE IS `250` w/ NO `-`
     */
    print(try connection.receive(max: 5000).string)

    try connection.send("AUTH LOGIN\r\n")
    print(try connection.receive(max: 5000).string)
    try connection.send("smtp.test".bytes.base64String + "\r\n")
    print(try connection.receive(max: 5000).string)
    try connection.send("smtp.pass1".bytes.base64String + "\r\n")
    print(try connection.receive(max: 5000).string)
    try connection.send("MAIL FROM:<smtp.test@sendgrid.com> BODY=8BITMIME\r\n")
    print(try connection.receive(max: 5000).string)
    try connection.send("RCPT TO:<logan.william.wright@gmail.com> \r\n")
    print(try connection.receive(max: 5000).string)
    try connection.send("DATA\r\n")
    print(try connection.receive(max: 5000).string)
    /*
     C: Date: Thu, 21 May 1998 05:33:22 -0700
     C: From: John Q. Public <JQP@bar.com>
     C: Subject:  The Next Meeting of the Board
     C: To: Jones@xyz.com
     */
    try connection.send("Date: \(RFC1123.now())\r\n")
    let id = NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
    print("ID: \(id)")
    try connection.send("Message-id: \(id)\r\n")
    try connection.send("From: Logan <logan.william.wright@gmail.com>\r\n")
    try connection.send("To: Logan <logan.william.wright@gmail.com>\r\n")
    try connection.send("Subject: Testing alternative date\r\n\r\n")
    try connection.send("Hello from smtp")
    try connection.send("\r\n.\r\n")
    print(try connection.receive(max: 5000).string)
    try connection.send("QUIT\r\n")
    print(try connection.receive(max: 5000).string)
    print("SMTP")
}


//var stream = try FoundationStream(host: "smtp.sendgrid.net", port: 2525, securityLayer: .none)
//let connection = try stream.connect()
//// 220 service ready greeting
//print(try connection.receive(max: 5000).string)
///*
// 220 smtp.gmail.com ESMTP p39sm303264qtp.14 - gsmtp
// */
//try connection.send("ehlo localhost \r\n")
//print(try connection.receive(max: 5000).string)
//try connection.send("STARTTLS\r\n")
//print(try connection.receive(max: 5000).string)
//stream = try FoundationStream(host: "smtp.sendgrid.net", port: 587, securityLayer: .tls)
//print(try connection.receive(max: 5000).string)
//print("")
let client = try SMTPClient<FoundationStream>(host: "smtp.sendgrid.net", port: 465, securityLayer: .tls)
try client.send()
print("")
//try originalWorkingSave()