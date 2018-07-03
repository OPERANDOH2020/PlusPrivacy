<div class="col-md-2 coin" data-toggle="modal" data-target="#<?php echo $modalId?>">
    <img class="alignleft size-medium"
         src="<?php echo $cryptoCurrency->icon; ?>"
         alt="<?php echo $cryptoCurrency->key;?>-symbol" width="48" height="48">
    <br>
    <span><?php echo $cryptoCurrency->name;?></span>
</div>


<div class="modal fade" id="<?php echo $modalId?>" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content donate_modal" >
            <div class="modal-header">
                <h3 class="modal-title">Donate <?php echo $cryptoCurrency->name;?></h3>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">

                <div align="center">
                    <img width="320px" height="320px;" src="<?php echo $cryptoCurrency->getQrCode();?>">
                </div>
                <br/>
                <p align="center">Please use this <?php echo $cryptoCurrency->name;?> address to donate. Thanks!</p>


                <div class="hash_container" align="center">
                    <div class="input-group">
                         <input style="background-image: url(<?php echo $cryptoCurrency->icon;?>)" type="text" class="form-control address_hash" readonly="readonly" value="<?php echo $cryptoCurrency->getAddress();?>">
                         <span class="input-group-btn">
                            <button class="btn btn-default copy_hash" type="button">Copy</button>
                        </span>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>