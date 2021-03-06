%%%-------------------------------------------------------------------
%%% File    : records.erl
%%% Author  : Thomas Habets <thomas@habets.se>
%%% Description : 
%%%
%%% Copyright :
%%% Copyright 2008,2011 Thomas Habets <thomas@habets.se>
%%%
%%% Licensed under the Apache License, Version 2.0 (the "License");
%%% you may not use this file except in compliance with the License.
%%% You may obtain a copy of the License at
%%%
%%%       http://www.apache.org/licenses/LICENSE-2.0
%%%
%%% Unless required by applicable law or agreed to in writing, software
%%% distributed under the License is distributed on an "AS IS" BASIS,
%%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%% See the License for the specific language governing permissions and
%%% limitations under the License.
%%%-------------------------------------------------------------------
-record(peer, {
	  ip,
	  port = 179,
	  as,
	  localport = 179,
	  localas,
	  passive = false}).

-record(route, {
	  net,
	  prefixlen,
	  nexthop
	  }).

-record(peer_state, {
	  connection,
	  peer
	  }).

-record(rib_state, {
	  tables = dict:new()
	 }).

-define(BGP_MARKER, 16#ffffffff).
-define(BGP_TYPE_OPEN, 1).
-define(BGP_TYPE_UPDATE, 2).
-define(BGP_TYPE_NOTIFICATION, 3).
-define(BGP_TYPE_KEEPALIVE, 4).
%% rfc2918 defines one more type


-define(BGP_HEADER_FMT, <<
			 ?BGP_MARKER:32,
			 ?BGP_MARKER:32,
			 ?BGP_MARKER:32,
			 ?BGP_MARKER:32,
			 _BGP_Head_Length:16,
			 _BGP_Head_Type:8,
			 _BGP_Head_rest/binary>>).

%% open
-define(BGP_VERSION, 4).
-define(BGP_OPEN_FMT, <<
		       ?BGP_MARKER:32,
		       ?BGP_MARKER:32,
		       ?BGP_MARKER:32,
		       ?BGP_MARKER:32,
		       _BGP_Length:16,
		       ?BGP_TYPE_OPEN:8,
		       ?BGP_VERSION:8,
		       _BGP_AS:16,
		       _BGP_Holdtime:16,
		       _BGP_Identifier:32,
		       _BGP_Opt_Parm_Len:8,
		       _BGP_Rest/binary>>).

-define(BGP_OPEN_PARM_FMT, <<_BGP_Open_Parm_Type:8,
			     _BGP_Open_Parm_Len:8,
			     _BGP_Open_Parm_Rest/binary>>).
-define(BGP_OPEN_PARM_CAPABILITIES, 2).

%% followed by BGP_Opt_Parm_Len bytes

%% keepalive
-define(BGP_KEEPALIVE_LENGTH, 19).
-define(BGP_KEEPALIVE_FMT, <<
			    ?BGP_MARKER:32,
			    ?BGP_MARKER:32,
			    ?BGP_MARKER:32,
			    ?BGP_MARKER:32,
			    ?BGP_KEEPALIVE_LENGTH:16,
			    ?BGP_TYPE_KEEPALIVE:8>>).

%% update
-define(BGP_UPDATE_FMT, <<
			 ?BGP_MARKER:32,
			 ?BGP_MARKER:32,
			 ?BGP_MARKER:32,
			 ?BGP_MARKER:32,
			 _BGP_Length:16,
			 ?BGP_TYPE_UPDATE:8,
			 _BGP_Update_Withdrawlen:16,
			 _BGP_Update_Rest_Withdraw/binary>>).
-define(BGP_UPDATE_FMT_WITHDRAW,
	<<
	 _BGP_Update_Withdraw:_BGP_Update_Withdrawlen/binary,
	 _BGP_Update_Pathattrlen:16,
	 _BGP_Update_Rest_Pathattr/binary>>).
-define(BGP_UPDATE_FMT_PATHATTR,
	<<
	 _BGP_Update_Pathattr:_BGP_Update_Pathattrlen/binary,
	 _BGP_Update_Info/binary>>).

-define(AS_SET, 1).
-define(AS_SEQUENCE, 2).

-define(CAP_MP_EXT, 1).
-define(CAP_ROUTE_REFRESH, 2).
-define(CAP_32BIT_AS, 65).
-define(CAP_ROUTE_REFRESH_128, 128).

-define(ORIGIN_IGP, 0).
-define(ORIGIN_EGP, 1).
-define(ORIGIN_INCOMPLETE, 2).
 
%% Update - Path attributes
-define(BGP_PATHATTR_ORIGIN, 1).
-define(BGP_PATHATTR_AS_PATH, 2).
-define(BGP_PATHATTR_NEXT_HOP, 3).
-define(BGP_PATHATTR_MULTI_EXIT_DISC, 4).
-define(BGP_PATHATTR_LOCAL_PREF, 5).
-define(BGP_PATHATTR_ATOMIC_AGGREGATE, 6).
-define(BGP_PATHATTR_AGGREGATOR, 7).
-define(BGP_PATHATTR_MP_REACH_NLRI, 14).

-define(BGP_PATHATTR_FLAG_OPTIONAL, 128).
-define(BGP_PATHATTR_FLAG_TRANSITIVE, 64).

-define(BGP_PATHATTR_AS_PATH_SET, 1).
-define(BGP_PATHATTR_AS_PATH_SEQUENTIAL, 2).


