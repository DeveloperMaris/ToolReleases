<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <channel>
        <title>{{ site.github.project_title }}</title>
        <description>Most recent changes with links to updates.</description>
        <language>en</language>
        {% for release in site.github.releases -%}
        {% unless release.draft -%}
        {% for asset in release.assets limit:1 -%}
        {% assign build_nums = asset.name | replace_first:'ToolReleases_v','' | replace_first:'.b',',' | remove_first:'.zip' | split:',' -%}
        {% if build_nums.size != 2 -%}
        {{ "Incorrect asset details provided." | raise_error }}
        {% endif -%}
        {% assign version = build_nums[1] -%}
        {% assign short_version = build_nums[0] | remove_first:'v' -%}
        {% assign signature = release.body | sparkle_signature -%}
        {% unless short_version < '1.5' -%}
        {% if signature == "" -%}
        {{ "Sparkle signature not found." | raise_error }}
        {% endif -%}
        <item>
            <title>{{ release.name }}</title>
            <link>https://github.com/DeveloperMaris/ToolReleases</link>
            <description><![CDATA[{{ release.body | markdownify | strip_newlines }}]]></description>
            <pubDate>{{ release.published_at | date_to_rfc822 }}</pubDate>
            <sparkle:minimumSystemVersion>11</sparkle:minimumSystemVersion>
            {% if release.prerelease -%}
            <sparkle:channel>beta</sparkle:channel>
            {% endif -%}
            <sparkle:version>{{ version }}</sparkle:version>
            <sparkle:shortVersionString>{{ short_version }}</sparkle:shortVersionString>
            <enclosure url="{{ asset.browser_download_url }}" length="{{ asset.size }}" sparkle:os="macos" type="application/octet-stream" sparkle:edSignature="{{ signature }}" />
        </item>
        {% endunless -%}
        {% endfor -%}
        {% endunless -%}
        {% endfor -%}
    </channel>
</rss>
