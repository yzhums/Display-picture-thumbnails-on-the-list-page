tableextension 50119 ItemExt extends Item
{
    fields
    {
        field(50100; "ZY Thumbnail"; BLOB)
        {
            Caption = 'Thumbnail';
            SubType = Bitmap;
        }
    }
}
pageextension 50119 ItemListExt extends "Item List"
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
    actions
    {
        addafter(Item)
        {
            action(UpdatePictureThumbnails)
            {
                Caption = 'Update Picture Thumbnails';
                Promoted = true;
                PromotedCategory = Process;
                Image = UpdateDescription;
                ApplicationArea = All;
                trigger OnAction()
                var
                    TenantMedia: Record "Tenant Media";
                begin
                    if Rec.FindSet() then
                        repeat
                            if Rec.Picture.Count > 0 then begin
                                if TenantMedia.Get(Rec.Picture.Item(1)) then begin
                                    TenantMedia.CalcFields(Content);
                                    Rec."ZY Thumbnail" := TenantMedia.Content;
                                    Rec.Modify(true);
                                end;
                            end else begin
                                if Rec."ZY Thumbnail".HasValue then begin
                                    Rec.CalcFields("ZY Thumbnail");
                                    Clear(Rec."ZY Thumbnail");
                                    Rec.Modify(true);
                                end;
                            end;
                        until Rec.Next() = 0;
                    Rec.FindFirst();
                end;
            }
        }
    }
}
