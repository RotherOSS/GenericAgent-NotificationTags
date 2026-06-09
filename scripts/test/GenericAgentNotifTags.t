# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
my $UserObject  = $Kernel::OM->Get('Kernel::System::User');

my ( $UserLogin, $UserID ) = $Helper->TestUserCreate();
ok(
    $UserID,
    "Test user $UserID created",
);

my $CustomerUserLogin = $Helper->TestCustomerUserCreate();
ok(
    $CustomerUserLogin,
    "Test customer user $CustomerUserLogin created",
);

my $TicketObject                 = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject                = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $InternalArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some test issue',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerUser => $CustomerUserLogin,
    OwnerID      => $UserID,
    UserID       => $UserID,
);
ok(
    $TicketID,
    "Ticket $TicketID created",
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => $UserID
);
my $ArticleID = $InternalArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    ArticleType          => 'note-internal',
    SenderType           => 'agent',
    From                 => "Agent <$UserLogin>",
    Subject              => 'Phone ticket',
    Body                 => 'Some test body.',
    ContentType          => 'text/plain; charset=utf8',
    HistoryType          => 'PhoneCallCustomer',
    HistoryComment       => 'First register',
    IsVisibleForCustomer => 1,
    UserID               => $UserID,
);
ok(
    $ArticleID,
    "Article $ArticleID created",
);

my $ArticleReplyID = $InternalArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    ArticleType          => 'email-external',
    SenderType           => 'customer',
    From                 => "Client <$CustomerUserLogin>",
    Subject              => 'Reply to ticket',
    Body                 => 'Reply body.',
    ContentType          => 'text/plain; charset=utf8',
    HistoryType          => 'EmailCustomer',
    HistoryComment       => 'Customer reply',
    IsVisibleForCustomer => 1,
    UserID               => $UserID,
);
ok(
    $ArticleReplyID,
    "Reply article $ArticleReplyID created",
);

my $JobData = {
    'NewModule'                        => '',
    'NewParamValue2'                   => '',
    'Title'                            => '',
    'EscalationSolutionTimeSearchType' => '',
    'EscalationTimeSearchType'         => '',
    'NewParamValue1'                   => '',
    'NewParamValue4'                   => '',
    'NewNoteTimeUnits'                 => '',
    'MIMEBase_Subject'                 => '',
    'NewParamKey2'                     => '',
    'NewTitle'                         => '',
    'NewParamKey5'                     => '',
    'CustomerID'                       => '',
    'EventValues'                      => ['ArticleEdit'],
    'NewCustomerUserLogin'             => '',
    'MIMEBase_To'                      => '',
    'LastCloseTimeSearchType'          => '',
    'NewNoteFrom'                      => 'someone@mail.org',
    'NewParamValue6'                   => '',
    'NewCustomerID'                    => '',
    'ScheduleLastRun'                  => '2025-08-27 10:37:18',
    'CloseTimeSearchType'              => '',
    'EscalationUpdateTimeSearchType'   => '',
    'EscalationResponseTimeSearchType' => '',

    # contain the tags to be replaced by the job upon success
    'NewNoteSubject' => 'New note on ticket id <OTOBO_TICKET_TicketID>',
    'NewNoteBody'    => 'Client is <OTOBO_CUSTOMER_REALNAME> and TicketNumber is <OTOBO_TICKET_TicketNumber>',

    'ChangeTimeSearchType'     => '',
    'NewDelete'                => '0',
    'NewPendingTime'           => '',
    'LastChangeTimeSearchType' => '',
    'TimePendingSearchType'    => '',
    'Name'                     => 'Test Job',
    'NewPendingTimeType'       => '60',
    'NewParamValue3'           => '',
    'TimeSearchType'           => '',
    'ScheduleLastRunUnixTime'  => '1756291038',
    'MIMEBase_From'            => '',
    'NewParamKey3'             => '',
    'MIMEBase_Cc'              => '',
    'CustomerUserLogin'        => '',
    'NewParamKey1'             => '',
    'NewSendNoNotification'    => '0',
    'MIMEBase_Body'            => '',
    'Valid'                    => '1',
    'TicketNumber'             => $Ticket{TicketNumber},
    'NewParamValue5'           => '',
    'NewParamKey4'             => '',
    'NewParamKey6'             => ''
};

my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');
my $JobAddResult       = $GenericAgentObject->JobAdd(
    Name   => "Job1",
    Data   => $JobData,
    UserID => $UserID,
);

my $Success = $GenericAgentObject->JobRun(
    Job    => 'Job1',
    UserID => 1,
);
ok(
    $Success,
    "Job executed with success",
);

my @ArticleList = $ArticleObject->ArticleList(
    TicketID => $TicketID,
);
is(
    scalar @ArticleList,
    3,
    "Job added new note to the ticket"
);

ARTICLE:
for my $ArticleElem (@ArticleList) {
    my %Article = $InternalArticleBackendObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleElem->{ArticleID},
    );

    # Only the new added note matters for checking
    next ARTICLE if $Article{Subject} !~ /New note/;

    my $ExpectedSubject = "New note on ticket id $TicketID";
    like(
        $Article{Subject},
        qr/\Q$ExpectedSubject\E/,
        "New note has the expected content in the subject"
    );

    # the TestCustomerUserCreate function sets both the customer's first and last name as the login
    my $CustomerUserFullName = "$CustomerUserLogin $CustomerUserLogin";
    my $ExpectedBody         = "Client is $CustomerUserFullName and TicketNumber is $Ticket{TicketNumber}";
    my $ArticleBody          = $Article{Body};
    $ArticleBody =~ s/[\r\n]/ /g;    # Sanitize any automatically inserted CR/LF characters
    like(
        $ArticleBody,
        qr/\Q$ExpectedBody\E/,
        "New note has the expected content in the body"
    );
}

done_testing;
