require "formula"

class Davmail < Formula
  homepage "http://davmail.sourceforge.net"
  url "http://downloads.sourceforge.net/project/davmail/davmail/4.4.1/davmail-4.4.1-2225.zip"
  sha1 "9c72ee52bda3615ee730c5eb2846b148e0bd714f"

  def install
    libexec.install Dir['*']
    open('davmail.properties', 'w') { |f| f.write DATA.read }
    prefix.install 'davmail.properties'
  end

  def caveats; <<-EOS.undent
    Configure davmail using #{opt_prefix}/davmail.properties before launching.
    EOS
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{libexec}/davmail.sh</string>
          <string>#{prefix}/davmail.properties</string>
        </array>
        <key>RunAtLoad</key>
        <true />
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end
end

__END__
# DavMail settings, see http://davmail.sourceforge.net/ for documentation

#############################################################
# Basic settings

# Server or workstation mode
davmail.server=true
# connection mode auto, EWS or WebDav
davmail.enableEws=auto
# base Exchange OWA or EWS url
davmail.url=https://mail.company.com/owa

# Listener ports
davmail.caldavPort=1080
davmail.imapPort=1143
davmail.ldapPort=1389
davmail.popPort=1110
davmail.smtpPort=1025

#############################################################
# Network settings

# Network proxy settings
davmail.enableProxy=false
davmail.useSystemProxies=false
davmail.proxyHost=
davmail.proxyPort=
davmail.proxyUser=
davmail.proxyPassword=

# proxy exclude list
davmail.noProxyFor=

# allow remote connection to DavMail
davmail.allowRemote=false
# bind server sockets to a specific address
davmail.bindAddress=localhost
# client connections SO timeout in seconds
davmail.clientSoTimeout=

# DavMail listeners SSL configuration
davmail.ssl.keystoreType=
davmail.ssl.keystoreFile=
davmail.ssl.keystorePass=
davmail.ssl.keyPass=

# Accept specified certificate even if invalid according to trust store
davmail.server.certificate.hash=

# disable SSL for specified listeners
davmail.ssl.nosecurecaldav=false
davmail.ssl.nosecureimap=false
davmail.ssl.nosecureldap=false
davmail.ssl.nosecurepop=false
davmail.ssl.nosecuresmtp=false

# disable update check
davmail.disableUpdateCheck=true

# Send keepalive character during large folder and messages download
davmail.enableKeepalive=false
# Message count limit on folder retrieval
davmail.folderSizeLimit=0

#############################################################
# Caldav settings

# override default alarm sound
davmail.caldavAlarmSound=
# retrieve calendar events not older than 90 days
davmail.caldavPastDelay=90
# WebDav only: force event update to trigger ActiveSync clients update
davmail.forceActiveSyncUpdate=false

#############################################################
# IMAP settings

# Delete messages immediately on IMAP STORE \Deleted flag
davmail.imapAutoExpunge=false
# Enable IDLE support, set polling delay in minutes
davmail.imapIdleDelay=

#############################################################
# POP settings

# Delete messages on server after 30 days
davmail.keepDelay=30
# Delete messages in server sent folder after 90 days
davmail.sentKeepDelay=90
# Mark retrieved messages read on server
davmail.popMarkReadOnRetr=false

#############################################################
# SMTP settings

# let Exchange save a copy of sent messages in Sent folder
davmail.smtpSaveInSent=true

#############################################################
# Loggings settings

# log file path, leave empty for default path
davmail.logFilePath=davmail.log
# maximum log file size, use Log4J syntax, set to 0 to use an external rotation mechanism, e.g. logrotate
davmail.logFileSize=1MB
# log levels
log4j.logger.davmail=WARN
log4j.logger.httpclient.wire=WARN
log4j.logger.org.apache.commons.httpclient=WARN
log4j.rootLogger=WARN

#############################################################
# Workstation only settings

# smartcard access settings
davmail.ssl.pkcs11Config=
davmail.ssl.pkcs11Library=

# SSL settings for mutual authentication
davmail.ssl.clientKeystoreType=
davmail.ssl.clientKeystoreFile=
davmail.ssl.clientKeystorePass=

# disable all balloon notifications
davmail.disableGuiNotifications=true
# disable startup balloon notifications
davmail.showStartupBanner=false

# enable transparent client Kerberos authentication
davmail.enableKerberos=false
