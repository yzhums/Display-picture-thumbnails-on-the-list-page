tableextension 50120 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50100; "ZY Thumbnail"; BLOB)
        {
            Caption = 'Thumbnail';
            SubType = Bitmap;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                TenantMedia: Record "Tenant Media";
                Item: Record Item;
            begin
                if Type = Type::Item then
                    if Item.Get("No.") then begin
                        if TenantMedia.Get(Item.Picture.Item(1)) then begin
                            TenantMedia.CalcFields(Content);
                            "ZY Thumbnail" := TenantMedia.Content;
                        end;
                    end;
            end;
        }
    }
}
pageextension 50120 SalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        addafter(Description)
        {
            field(Thumbnail; Rec."ZY Thumbnail")
            {
                ApplicationArea = All;
            }
        }
    }
}
