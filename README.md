# Cilium egress gateway interruption reproduction

This is a reproduction for [cilium/cilium#23289](https://github.com/cilium/cilium/issues/23289),
in which the Cilium egress gateway interrupts long-running TCP connections.

Here's the setup:

  * A kind cluster with Cilium installed.
    * Nodes are named `cilium-repro-worker`, `cilium-repro-worker2`, and
      `cilium-repro-worker3`.
    * `cilium-repro-worker` is the designated egress node.
  * A "long-conn" workload which runs `curl
    https://stream.wikimedia.org/v2/stream/recentchange` on a *non-egress* node
    (`cilium-repro-worker3`). This is a "server-sent events" (SSE) stream that
    involves the server (Wikipedia) continuously sending data to the client,
    without application level acknowledgement of that data.
  * A conntrack GC interval of 90s. Whenever GC runs, it will corrupt the
    long-conn connection.

## Instructions

First, run `bin/create` to create a kind cluster, install Cilium, configure the
egress policy, and start the workloads.

Then, in two separate terminals, run:

  * `bin/watch-cilium`, which displays the number of entries in the Cilium
    NAT map on the egress gateway.
  * `bin/watch-curl`, which tails the logs of the Wikipedia stream from the
    "long-conn" workload.

The number of entries in the NAT map will steadily grow. All the while, the
Wikipedia stream will be steadily producing data.

After 90s, conntrack GC will run, and corrupt the long-conn connection. This
will present as the Wikipedia stream hanging (watch closely!). After about 15s,
`curl` will notice the hung connection (via TCP keepalives) and exit with a
"connection reset by peer" error.

To manually trigger conntrack GC, run `bin/conntrack-gc`.
