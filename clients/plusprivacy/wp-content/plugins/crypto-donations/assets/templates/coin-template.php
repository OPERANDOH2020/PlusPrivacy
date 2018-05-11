<div class="col-md-2 coin" data-toggle="modal" data-target="#<?php echo $modalId?>">
    <img class="alignleft size-medium"
         src="<?php echo $cryptoCurrency->icon; ?>"
         alt="<?php echo $cryptoCurrency->key;?>-symbol" width="48" height="48">
    <br>
    <span><?php echo $cryptoCurrency->name;?></span>
</div>

<!-- Modal -->
<div class="modal fade" id="<?php echo $modalId?>" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <img src="<?php echo $cryptoCurrency->getQrCode();?>">

                <span><?php echo $cryptoCurrency->getHash();?></span>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Save changes</button>
            </div>
        </div>
    </div>
</div>