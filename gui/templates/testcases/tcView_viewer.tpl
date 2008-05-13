{*
TestLink Open Source Project - http://testlink.sourceforge.net/
$Id: tcView_viewer.tpl,v 1.17 2008/05/13 12:38:20 franciscom Exp $
viewer for test case in test specification

20080425 - franciscom - removed php notice
20080113 - franciscom - changed format for test case id + name
20071204 - franciscom - display execution_type
20070628 - franciscom - active_status_op_enabled always true
20061230 - franciscom - an experiment to make simple management
                        of frequent used href
*}

{lang_get var="labels"
          s="requirement_spec,Requirements,tcversion_is_inactive_msg,
             btn_edit,btn_del,btn_mv_cp,btn_del_this_version,btn_new_version,
             btn_export,btn_execute_automatic_testcase,version,
             testproject,testsuite,title_test_case,summary,steps,
             title_last_mod,title_created,by,expected_results,keywords,
             execution_type,step,test_importance,none"}



             
{assign var="hrefReqSpecMgmt" value="lib/general/frmWorkArea.php?feature=reqSpecMgmt"}
{assign var="hrefReqSpecMgmt" value=$basehref$hrefReqSpecMgmt}

{assign var="hrefReqMgmt" value="lib/requirements/reqView.php?showReqSpecTitle=1&requirement_id="}
{assign var="hrefReqMgmt" value=$basehref$hrefReqMgmt}
{assign var="author_userinfo" value=$args_users[$args_testcase.author_id]}
{assign var="updater_userinfo" value=""}
{if $args_testcase.updater_id != ''}
  {assign var="updater_userinfo" value=$args_users[$args_testcase.updater_id]}
{/if}

{if $args_show_title == "yes"}
    {if $args_tproject_name != ''}
     <h2>{$labels.testproject} {$args_tproject_name|escape} </h2>
     <br />
    {/if}
    {if $args_tsuite_name != ''}
     <h2>{$labels.testsuite} {$args_tsuite_name|escape} </h2>
     <br />
    {/if}

	<h2>{$labels.title_test_case} {$args_testcase.name|escape} </h2>
{/if}


{if $args_can_edit == "yes" }

  {assign var="edit_enabled" value=0}
  {* 20070628 - franciscom
     Seems logical you can disable some you have executed before*}
  {assign var="active_status_op_enabled" value=1}
  {assign var="has_been_executed" value=0}
  {lang_get s='can_not_edit_tc' var="warning_edit_msg"}
  {if $args_status_quo eq null or
      $args_status_quo[$args_testcase.id].executed eq null}

      {assign var="edit_enabled" value=1}
      {* {assign var="active_status_op_enabled" value=1}  *}
      {assign var="warning_edit_msg" value=""}

  {else}
     {if $args_tcase_cfg->can_edit_executed eq 1}
       {assign var="edit_enabled" value=1}
       {assign var="has_been_executed" value=1}
       {lang_get s='warning_editing_executed_tc' var="warning_edit_msg"}
     {/if}
  {/if}


  <div class="groupBtn">

	<span style="float: left"><form method="post" action="lib/testcases/tcEdit.php">
	  <input type="hidden" name="testcase_id" value="{$args_testcase.testcase_id}" />
	  <input type="hidden" name="tcversion_id" value="{$args_testcase.id}" />
	  <input type="hidden" name="has_been_executed" value="{$has_been_executed}" />
	  <input type="hidden" name="doAction" value="" />


	    {assign var="go_newline" value=""}
	    {if $edit_enabled}
	 	    <input type="submit" name="edit_tc" 
	 	           onclick="doAction.value='edit'" value="{$labels.btn_edit}" />
	    {/if}
	
		{if $args_can_delete_testcase == "yes" }
			<input type="submit" name="delete_tc" value="{$labels.btn_del}" />
	    {/if}
	
	    {if $args_can_move_copy == "yes" }
	   		<input type="submit" name="move_copy_tc"   value="{$labels.btn_mv_cp}" />
	     	{assign var="go_newline" value="<br />"}
	    {/if}
	
	 	{if $args_can_delete_version == "yes" }
			 <input type="submit" name="delete_tc_version" value="{$labels.btn_del_this_version}" />
	    {/if}

   		<input type="submit" name="do_create_new_version"   value="{$labels.btn_new_version}" />
	
		{* --------------------------------------------------------------------------------------- *}
		{if $active_status_op_enabled eq 1}
	        {if $args_testcase.active eq 0}
				{assign var="act_deact_btn" value="activate_this_tcversion"}
				{assign var="act_deact_value" value="activate_this_tcversion"}
				{assign var="version_title_class" value="inactivate_version"}
	      	{else}
				{assign var="act_deact_btn" value="deactivate_this_tcversion"}
				{assign var="act_deact_value" value="deactivate_this_tcversion"}
				{assign var="version_title_class" value="activate_version"}
	      	{/if}
	      	<input type="submit" name="{$act_deact_btn}"
	                           value="{lang_get s=$act_deact_value}" />
	    {/if}
	</form></span>

	<span>
	<form method="post" action="lib/testcases/tcExport.php" name="tcexport">
		<input type="hidden" name="testcase_id" value="{$args_testcase.testcase_id}" />
		<input type="hidden" name="tcversion_id" value="{$args_testcase.id}" />
		<input type="submit" name="export_tc" style="margin-left: 3px;" value="{$labels.btn_export}" />
		{* 20071102 - franciscom *}
		{*
		<input type="button" name="tstButton" value="{$labels.btn_execute_automatic_testcase}"
		       onclick="javascript: startExecution({$args_testcase.testcase_id},'testcase');" />
		*}
	</form></span>
  </div> {* class="groupBtn" *}

{/if} {* user can edit *}


{* --------------------------------------------------------------------------------------- *}
  {if $args_testcase.active eq 0}
    <br /><div class="warning_message" align="center">{$labels.tcversion_is_inactive_msg}</div>
  {/if}
 	{if $warning_edit_msg neq ""}
 	    <br /><div class="warning_message" align="center">{$warning_edit_msg}</div>
 	{/if}
 
<table class="simple">
    {if $args_show_title == "yes"}
	<tr>
		<th colspan="2">
		{$args_testcase.tc_external_id}{$smarty.const.TITLE_SEP}{$args_testcase.name|escape}</th>
	</tr>
    {/if}

  {if $args_show_version == "yes"}

{*     {if $warning_edit_msg neq ""}
	    <tr>
	      <td class="warning_message" align="center" colspan="2">{$warning_edit_msg}</td>
	    </tr>
    {/if}
*}    
	  <tr>
	  	<td class="bold" colspan="2">{$labels.version}
	  	{$args_testcase.version|escape}
	  	</td>
	  </tr>
	{/if}

	<tr class="time_stamp_creation">
  		<td width="50%">
      		{$labels.title_created}&nbsp;{localize_timestamp ts=$args_testcase.creation_ts }&nbsp;
      		{$labels.by}&nbsp;{$author_userinfo->getDisplayName()|escape}
  		</td>
  		{if $args_testcase.updater_last_name ne "" || $args_testcase.updater_first_name ne ""}
    	<td width="50%">
    		{$labels.title_last_mod}&nbsp;{localize_timestamp ts=$args_testcase.modification_ts}
		  	&nbsp;{$labels.by}&nbsp;{$updater_userinfo->getDisplayName()|escape}
    	</td>
  		{/if}
    </tr>

	<tr>
		<td class="bold" colspan="2">{$labels.summary}</td>
	</tr>

	<tr>
		<td colspan="2">{$args_testcase.summary}</td>
	</tr>
	<tr>
		<th width="50%">{$labels.steps}</th>
		<th width="50%">{$labels.expected_results}</th>
	</tr>
	<tr>
		<td>{$args_testcase.steps}</td>
		<td>{$args_testcase.expected_results}</td>
	</tr>
</table>
    {if $session['testprojectOptAutomation']}
    <div>
		<span class="labelHolder">{$labels.execution_type} {$smarty.const.TITLE_SEP}</span>
		{$execution_types[$args_testcase.execution_type]}
	</div>
	{/if}

    {if $session['testprojectOptPriority']}
    <div>
		<span class="labelHolder">{$labels.test_importance} {$smarty.const.TITLE_SEP}</span>
		{$gsmarty_option_importance[$args_testcase.importance]}
	</div>
	{/if}

	{if $args_cf neq ''}
	<div>
        <div class="custom_field_container">{$args_cf}</div>
	</div>
	{/if}

	<div>
		<table cellpadding="0" cellspacing="0" style="font-size:100%;">
			    <tr>
			     	<td width="35%" style="vertical-align:text-top;"><a href={$gsmarty_href_keywordsView}>{$labels.keywords}</a>: &nbsp;
						</td>
				 	  <td>
					  	{foreach item=keyword_item from=$args_keywords_map}
						    {$keyword_item|escape}
						    <br />
	      				{foreachelse}
    	  					{$labels.none}
						{/foreach}
					</td>
				</tr>
				</table>
	</div>

	{if $opt_requirements == TRUE && $view_req_rights == "yes"}
	<div>
		<table cellpadding="0" cellspacing="0" style="font-size:100%;">
     			  <tr>
       			  <td colspan="2" style="vertical-align:text-top;"><span><a title="{$labels.requirement_spec}" href="{$hrefReqSpecMgmt}"
      				target="mainframe" class="bold">{$labels.Requirements}</a>
      				: &nbsp;</span>
      			  </td>
      			  <td>
      				{section name=item loop=$args_reqs}
      					<span onclick="javascript: open_top('{$hrefReqMgmt}{$args_reqs[item].id}');"
      					style="cursor:  pointer;">[{$args_reqs[item].req_spec_title|escape}]&nbsp;{$args_reqs[item].req_doc_id|escape}:{$args_reqs[item].title|escape}</span>
      					{if !$smarty.section.item.last}<br />{/if}
      				{sectionelse}
      					{$labels.none}
      				{/section}
      			  </td>
    		    </tr>
	  </table>
	</div>
	{/if}