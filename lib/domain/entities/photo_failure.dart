/// Why photos could not be loaded. The UI picks a message from [kind] without knowing the network library.
enum PhotoFailureKind { network, server, unknown }

class PhotoFailure implements Exception {
  const PhotoFailure(this.kind);

  final PhotoFailureKind kind;

  @override
  String toString() => 'PhotoFailure($kind)';
}
