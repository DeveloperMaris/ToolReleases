<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <channel>
        <title>{{ site.github.project_title }}</title>
        <description>Most recent changes with links to updates.</description>
        <language>en</language>
        {% for release in site.github.releases -%}
            {% unless release.draft -%}
                {% unless release.prerelease and page.release_only -%}
        <item>
            <title>{{ release.name }}</title>
            <link>https://github.com/DeveloperMaris/ToolReleases</link>
            <description><![CDATA[{{ release.body | markdownify | strip_newlines }}]]></description>
            <pubDate>{{ release.published_at | date_to_rfc822 }}</pubDate>
                        {% for asset in release.assets limit:1 -%}
                            {% assign signature = release.body | sparkle_signature -%}

                            {% assign build_nums = asset.name | replace_first:'ToolReleases_v','' | replace_first:'.b',',' | remove_first:'.zip' | split:',' -%}
                            {% if build_nums.size == 2 -%}
                                {% assign version = build_nums[1] -%}
                                {% assign short_version = build_nums[0] | remove_first:'v' -%}
                                {% if short_version < '1.4' -%}
            <sparkle:minimumSystemVersion>10.15</sparkle:minimumSystemVersion>
                                {% elsif short_version < '1.5' -%}
            <sparkle:minimumSystemVersion>10.16</sparkle:minimumSystemVersion>
                                {% else -%}
            <sparkle:minimumSystemVersion>11</sparkle:minimumSystemVersion>
                                {% endif -%}
                            {% else -%}
                                {% assign version = release.tag_name | remove_first:'v' -%}
                            {% endif -%}
            <sparkle:version>{{ version }}</sparkle:version>
                            {% if short_version -%}
            <sparkle:shortVersionString>{{ short_version }}</sparkle:shortVersionString>
                            {% endif -%}
            <enclosure
                    url="{{ asset.browser_download_url }}"
                    {% if signature != "" -%}
                    sparkle:edSignature="{{ signature }}"
                    {% endif -%}
                    sparkle:os="macos"
                    length="{{ asset.size }}"
                    type="application/octet-stream" />
                        {% endfor -%}
        </item>
                {% endunless -%}
            {% endunless -%}
        {% endfor -%}
    </channel>
</rss>
