# Riak Protocol Buffers Messages

![Riak PB OpenRiak Status](https://github.com/OpenRiak/riak_pb/actions/workflows/erlang.yml/badge.svg?branch=openriak-3.2)

This repository contains the message definitions for the Protocol
Buffers-based interface to [Riak](https://github.com/OpenRiak/riak) and
various Erlang-specific utility modules for the message types.

This is distributed separately from the Riak server and clients,
allowing it to serve as an independent representation of the supported
messages. Additionally, the `.proto` descriptions are broken out by
functional area:

* `riak.proto` contains "global" messages like the error message and
  the "server info" calls.
* `riak_kv.proto` contains messages related to Riak KV.

Other specifications may arise as more features are exposed via the PB
interface.

## Protocol

The Riak PBC protocol encodes requests and responses as Protocol
Buffers messages.  Each request message results in one or more
response messages.  As message type and length are not encoded by PB,
they are sent on the wire as:

    <length:32> <msg_code:8> <pbmsg>

* `length` is the length of `msg_code` (1 byte) plus the message length
  in bytes encoded in network order (big endian).

* `msg_code` indicates what is encoded as `pbmsg`

* `pbmsg` is the encoded protocol buffer message

On connect, the client can make requests and will receive responses.
For each request message there is a corresponding response message, or
the server will respond with an error message if something has gone
wrong.

The client should be prepared to handle messages without any `pbmsg`
(i.e. `length == 1`) for requests where the response is simply an
acknowledgment.

In some cases, a client may receive multiple response messages for a
single request. The response message will typically include a boolean
`done` field that signifies the last message in a sequence.
