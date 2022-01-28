# NAME

Dist::Zilla::Plugin::MinimumPerlFast - Quickly detects the minimum version of Perl required for your dist

# VERSION

version 0.005

# DESCRIPTION

This plugin uses [Perl::MinimumVersion::Fast](https://metacpan.org/pod/Perl%3A%3AMinimumVersion%3A%3AFast) to automatically find the minimum version of Perl required for your dist and adds it to the prereqs.

```
# In your dist.ini:
[MinimumPerlFast]
```

This plugin will search for files matching `/\.(t|pl|pm)$/i` in the `lib/`, `bin/`, and `t/` directories.

# ATTRIBUTES

## version

The minimum version of perl for this module. Determining this is the reason for existence of this module, but if necessary this can easily be overridden.

## default\_version

The minimum version that is used if no minimum can be detected. By default it's `5.008` because that's the oldest that `Perl::MinimumVersion::Fast` can detect.

# SEE ALSO
Dist::Zilla

# AUTHOR

Leon Timmermans <leont@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Leon Timmermans.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
