class mongodb32xenial::repo (
  $comment,
  $location,
  $release,
  $repos,
    $key_id,
  $key_server,
  $incl_src,
  $incl_deb
) {
  apt::source { 'mongodb32':
    ensure   => present,
    comment  => $comment,
    location => $location,
    release  => $release,
    repos    => $repos,
    key      => {
      'id'     => $key_id,
      'server' => $key_server,
    },
    include  => {
      'src' => $incl_src,
      'deb' => $incl_deb,
    },
  }
}