<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Home Page
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script id="user-table-template" type="text/html">
        <tr id="user-row-${Id}">
            <td>
                <span id="user-first-name-span-${Id}">${FirstName}</span>
                <input id="user-first-name-text-${Id}" type="text" style="display:none;" value="${FirstName}"/>
            </td>
            <td>
                <span id="user-last-name-span-${Id}">${LastName}</span>
                <input id="user-last-name-text-${Id}" type="text" style="display:none;" value="${LastName}"/>
            </td>
            <td>
                <a id="user-edit-${Id}" href="#" onclick="editUser(${Id}); return false;">Edit</a>
                <span id="user-apply-cancel-${Id}" style="display:none;">
                    <a href="#" onclick="editUser(${Id}); updateUser(${Id}); return false;">Apply</a>&nbsp;
                    <a href="#" onclick="editUser(${Id}); return false;">Cancel</a>
                </span>&nbsp;
                <a href="#" onclick="deleteUser(${Id}); return false;">Delete</a>&nbsp;
            </td>
        </tr>
    </script>

<strong>Users:</strong>
    <table id="users-table">
        <thead>
            <tr>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody id="user-table-body">
        </tbody>
        <tfoot>
            <tr>
                <td><input id="user-new-first-name" type="text" /></td>
                <td><input id="user-new-last-name" type="text" /></td>
                <td><a href="#" onclick="insertUser(); return false;">Create User</a></td>
            </tr>
        </tfoot>
    </table>
    
    
    <script type="text/javascript">
        $(document).ready(function () {
            getUsers();
        });

        function getUsers() {
            $("#user-table-body").empty();
            $.getJSON("ODataPrototype/PrototypeDataService.svc/Users", function (response) {
                $("#user-table-template").tmpl(response.d).appendTo("#user-table-body");
            });
        }

        function editUser(id) {
            $('#user-edit-' + id).toggle();
            $('#user-first-name-span-' + id).toggle();
            $('#user-first-name-text-' + id).toggle();
            $('#user-last-name-span-' + id).toggle();
            $('#user-last-name-text-' + id).toggle();
            $('#user-apply-cancel-' + id).toggle();
        }

        function updateUser(id) {
            var user = { Id: id, FirstName: $('#user-first-name-text-' + id).val(), LastName: $('#user-last-name-text-' + id).val() };

            var json = JSON.stringify(user);

            $.ajax({
                type: "PUT",
                contentType: "application/json",
                url: "ODataPrototype/PrototypeDataService.svc/Users(" + id + ")",
                data: json,
                dataType: "json",
                success: function () {
                    $('#user-row-' + id).replaceWith($("#user-table-template").tmpl(user));
                }
            });
        }

        function insertUser() {
            var user = { FirstName: $('#user-new-first-name').val(), LastName: $('#user-new-last-name').val() };

            var json = JSON.stringify(user);

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ODataPrototype/PrototypeDataService.svc/Users",
                data: json,
                dataType: "json",
                success: function (response) {
                    $("#user-table-template").tmpl(response.d).appendTo("#user-table-body");
                    $('#user-new-first-name').val('');
                    $('#user-new-last-name').val('');
                }
            });
        }

        function deleteUser(id) {
            $.ajax({
                type: "DELETE",
                contentType: "application/json; charset=utf-8",
                url: "ODataPrototype/PrototypeDataService.svc/Users(" + id + ")",
                dataType: "json",
                success: function () {
                    $('#user-row-' + id).fadeOut(function () {
                        $('#user-row-' + id).remove();
                    });
                }
            });
        }
    </script>
</asp:Content>
